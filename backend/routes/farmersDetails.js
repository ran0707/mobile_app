// backend/routes/farmersDetails.js

const express = require('express');
const router = express.Router();
const User = require('../models/userdetails');
const Otp = require('../models/otp');
const logger = require('../logger'); // Logger setup

// Utility function to generate a default OTP (for development)
const generateDefaultOtp = () => {
    return '123456'; // Fixed OTP for development
};

// POST /api/farmers/send-otp
router.post('/send-otp', async (req, res) => {
    const { phone, name } = req.body;

    // Input validation
    if (!phone || !name) {
        logger.warn(`OTP request with missing fields: ${JSON.stringify(req.body)}`);
        return res.status(400).json({ message: 'Name and phone number are required.' });
    }

    logger.info(`Received OTP request for phone: ${phone}, name: ${name}`);

    try {
        // Generate a default OTP
        const otpCode = generateDefaultOtp();
        logger.info(`Generated OTP for phone ${phone}: ${otpCode}`);

        // Save or update OTP in the database
        let otpRecord = await Otp.findOne({ phone });
        if (otpRecord) {
            otpRecord.otp = otpCode;
            otpRecord.createdAt = Date.now();
            await otpRecord.save();
            logger.info(`Updated existing OTP for phone: ${phone}`);
        } else {
            otpRecord = new Otp({
                phone,
                otp: otpCode,
            });
            await otpRecord.save();
            logger.info(`Saved new OTP for phone: ${phone}`);
        }

        // **For Development Only:** Return the OTP in the response
        // **Remove this in Production!**
        res.status(200).json({ message: 'OTP sent successfully.', otp: otpCode });
    } catch (error) {
        logger.error(`Error in /send-otp: ${error.message}`);
        res.status(500).json({ message: 'An error occurred while sending OTP. Please try again.' });
    }
});

// POST /api/farmers/verify-otp
router.post('/verify-otp', async (req, res) => {
    const { phone, otp_code, address, city, state, country } = req.body;

    // Input validation
    if (!phone || !otp_code || !address || !city || !state || !country) {
        logger.warn(`OTP verification attempt with missing fields: ${JSON.stringify(req.body)}`);
        return res.status(400).json({ message: 'All fields are required.' });
    }

    logger.info(`Received OTP verification request for phone: ${phone}`);

    try {
        // Find the OTP record
        const otpRecord = await Otp.findOne({ phone, otp: otp_code });
        if (!otpRecord) {
            logger.warn(`Invalid OTP attempt for phone: ${phone}`);
            return res.status(400).json({ message: 'Invalid or expired OTP.' });
        }

        // OTP is valid; proceed to save user details
        const existingUser = await User.findOne({ phone });
        if (existingUser) {
            logger.warn(`User with phone ${phone} already exists.`);
            return res.status(400).json({ message: 'User already registered.' });
        }

        const user = new User({
            phone,
            name: req.body.name, // Ensure 'name' is sent during verification if needed
            address,
            city,
            state,
            country,
            isVerified: true,
        });

        await user.save();
        logger.info(`User registered and verified: ${phone}`);

        // Delete the OTP record
        await Otp.deleteOne({ _id: otpRecord._id });
        logger.info(`Deleted OTP record for phone: ${phone}`);

        res.status(200).json({ message: 'OTP verified and user registered successfully.' });
    } catch (error) {
        logger.error(`Error in /verify-otp: ${error.message}`);
        res.status(500).json({ message: 'An error occurred during verification. Please try again.' });
    }
});

module.exports = router;
