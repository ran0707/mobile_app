// backend/routes/inference.js

const express = require('express');
const router = express.Router();
const multer = require('multer');
const { InferenceSession, Tensor } = require('onnxruntime-node');
const fs = require('fs');
const path = require('path');
const logger = require('../logger');
const sharp = require('sharp'); // For image preprocessing
const Detection = require('../models/Detection'); // Detection Model

// Configure multer for file uploads
const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, 'uploads/'); // Ensure this directory exists
    },
    filename: function (req, file, cb) {
        cb(null, Date.now() + path.extname(file.originalname)); // Append timestamp
    }
});
const upload = multer({ 
    storage: storage,
    limits: { fileSize: 10 * 1024 * 1024 }, // 10 MB limit
});

// Class to Label Mapping
const class_to_idx = {
    'background': 0,
    'rsc': 1,
    'looper': 2,
    'rsm': 3,
    'thrips': 4,
    'jassid': 5,
    'tmb': 6, 
    'healthy': 7
};

// Reverse mapping
const idx_to_class = Object.keys(class_to_idx).reduce((obj, key) => {
    obj[class_to_idx[key]] = key;
    return obj;
}, {});

// Recommendations based on class
const recommendations = {
    'background': 'No action required.',
    'rsc': 'Recommendation for RSC: Apply appropriate pesticides and ensure proper irrigation.',
    'looper': 'Recommendation for Looper: Use biological control methods and monitor regularly.',
    'rsm': 'Recommendation for RSM: Prune affected areas and apply fungicides as needed.',
    'thrips': 'Recommendation for Thrips: Introduce natural predators and use insecticidal soaps.',
    'jassid': 'Recommendation for Jassid: Apply neem oil and maintain plant hygiene.',
    'tmb': 'Recommendation for TMB: Use cultural practices to reduce habitat for pests.',
    'healthy': 'Healthy leaf detected. Maintain proper care to ensure continued plant health.'
};

// Symptoms based on class
const symptoms = {
    'background': 'No symptoms detected.',
    'rsc': 'Symptoms of RSC: Yellowing leaves and stunted growth.',
    'looper': 'Symptoms of Looper: Presence of caterpillar-like pests on leaves.',
    'rsm': 'Symptoms of RSM: Black spots and mold growth on leaves.',
    'thrips': 'Symptoms of Thrips: Silvering of leaves and distorted growth.',
    'jassid': 'Symptoms of Jassid: Sticky honeydew and sooty mold on plants.',
    'tmb': 'Symptoms of TMB: Wilting and leaf discoloration.',
    'healthy': 'No symptoms detected.'
};

// Load ONNX model once
let session;
(async () => {
    try {
        session = await InferenceSession.create('./assets/model/model.onnx');
        logger.info('ONNX model loaded successfully.');
    } catch (error) {
        logger.error('Failed to load ONNX model:', error);
    }
})();

// Helper function to preprocess image
const preprocessImage = async (imagePath) => {
    try {
        // Resize image to 224x224 (modify as per your model's requirements)
        const resizedBuffer = await sharp(imagePath)
            .resize(224, 224)
            .raw()
            .toBuffer();

        // Normalize pixel values to [0, 1] and convert to Float32Array
        const floatArray = new Float32Array(resizedBuffer.length);
        for (let i = 0; i < resizedBuffer.length; i++) {
            floatArray[i] = resizedBuffer[i] / 255.0;
        }

        // Assuming the model expects input shape [1, 3, 224, 224]
        const tensor = new Tensor('float32', floatArray, [1, 3, 224, 224]);
        return tensor;
    } catch (error) {
        logger.error('Error in preprocessing image:', error);
        throw error;
    }
};

// Helper function to save mask images
const saveMaskImage = async (maskBuffer, detectionId, index) => {
    const maskPath = `masks/${detectionId}_${index}.png`; // Ensure 'masks' directory exists
    await sharp(Buffer.from(maskBuffer))
        .toFile(maskPath);
    return maskPath;
};

// Helper function to postprocess inference results
const postprocessResults = async (results, imagePath) => {
    // Replace 'boxes', 'labels', 'scores', 'masks' with your model's actual output names
    const boxes = results['boxes'].data;   // Float32Array [num_detections, 4]
    const labels = results['labels'].data; // Int64Array [num_detections]
    const scores = results['scores'].data; // Float32Array [num_detections]
    const masks = results['masks'].data;   // Float32Array [num_detections, mask_height, mask_width]

    const numDetections = scores.length;
    const maskHeight = results['masks'].dims[1];
    const maskWidth = results['masks'].dims[2];

    const detections = [];

    for (let i = 0; i < numDetections; i++) {
        const score = scores[i];
        if (score < 0.5) continue; // Confidence threshold

        const labelIdx = labels[i];
        const detectedClass = idx_to_class[labelIdx] || 'unknown';
        const confidence = score;

        // Extract bounding box
        const x1 = boxes[i * 4];
        const y1 = boxes[i * 4 + 1];
        const x2 = boxes[i * 4 + 2];
        const y2 = boxes[i * 4 + 3];

        // Extract mask for this detection
        const maskStart = i * maskHeight * maskWidth;
        const maskEnd = maskStart + maskHeight * maskWidth;
        const maskData = masks.slice(maskStart, maskEnd);

        // Convert mask data to binary mask image
        const binaryMask = maskData.map(value => value > 0.5 ? 255 : 0); // Thresholding

        // Save mask image
        const detectionId = path.basename(imagePath, path.extname(imagePath));
        const maskPath = await saveMaskImage(binaryMask, detectionId, i);

        // Get symptoms and recommendation
        const detectedSymptoms = symptoms[detectedClass] || 'No symptoms detected.';
        const detectedRecommendation = recommendations[detectedClass] || 'No recommendation available.';

        detections.push({
            boundingBox: { x1, y1, x2, y2 },
            detectedClass,
            confidence,
            maskPath,
            symptoms: detectedSymptoms,
            recommendation: detectedRecommendation
        });
    }

    return detections;
};

// @route   POST /api/inference
// @desc    Perform inference on uploaded image
// @access  Public (Secure in production)
router.post('/', upload.single('image'), async (req, res) => {
    if (!session) {
        return res.status(500).json({ message: 'Model not loaded.' });
    }

    if (!req.file) {
        return res.status(400).json({ message: 'No image uploaded.' });
    }

    const { locality, latitude, longitude } = req.body;

    if (!locality) {
        return res.status(400).json({ message: 'Locality is required.' });
    }

    try {
        // Preprocess the image
        const inputTensor = await preprocessImage(req.file.path);

        // Run inference
        const feeds = { 'input': inputTensor }; // Replace 'input' with your model's input name
        const results = await session.run(feeds);

        // Postprocess results
        const detections = await postprocessResults(results, req.file.path);

        // Save each detection to the database
        for (const det of detections) {
            const detection = new Detection({
                imagePath: req.file.path,
                maskPath: det.maskPath,
                locality: locality,
                latitude: latitude ? parseFloat(latitude) : null,
                longitude: longitude ? parseFloat(longitude) : null,
                detectedClass: det.detectedClass,
                confidence: det.confidence,
                symptoms: det.symptoms,
                recommendation: det.recommendation
            });

            await detection.save();
        }

        // Respond with detection details
        res.json({
            detections: detections.map(det => ({
                boundingBox: det.boundingBox,
                detectedClass: det.detectedClass,
                confidence: det.confidence,
                maskPath: det.maskPath,
                symptoms: det.symptoms,
                recommendation: det.recommendation
            }))
        });
    } catch (error) {
        logger.error('Inference error:', error);
        res.status(500).json({ message: 'Inference failed.' });
    }
});

module.exports = router;
