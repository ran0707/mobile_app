// backend/models/Detection.js

const mongoose = require('mongoose');

const DetectionSchema = new mongoose.Schema({
    imagePath: {
        type: String,
        required: true
    },
    maskPath: {
        type: String,
        required: true
    },
    locality: {
        type: String,
        required: true
    },
    latitude: {
        type: Number, // Optional, if you have precise coordinates
    },
    longitude: {
        type: Number, // Optional, if you have precise coordinates
    },
    detectedClass: {
        type: String,
        required: true,
        enum: ['background', 'rsc', 'looper', 'rsm', 'thrips', 'jassid', 'tmb', 'healthy']
    },
    confidence: {
        type: Number,
        required: true
    },
    symptoms: {
        type: String,
        required: true
    },
    recommendation: {
        type: String,
        required: true
    },
    timestamp: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Detection', DetectionSchema);
