// backend/models/Otp.js

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const OtpSchema = new Schema({
    phone: {
        type: String, // Using String for consistency
        required: true,
        unique: true,
    },
    otp: { // Stores the OTP code
        type: String,
        required: true,
    },
    createdAt: {
        type: Date,
        default: Date.now,
        index: { expires: '2m' }, // OTP expires after 2 minutes
    },
});

module.exports = mongoose.model('Otp', OtpSchema);
