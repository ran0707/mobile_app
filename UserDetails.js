// backend/models/UserDetails.js

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    phone: {
        type: String, // Changed from Number to String for leading zeros and flexibility
        required: true,
        unique: true,
    },
    name: {
        type: String,
        required: true,
    },
    address: { // Aligned with route handler
        type: String,
        required: true,
    },
    city: { // Aligned with route handler
        type: String,
        required: true,
    },
    state: { // Added to match route handler
        type: String,
        required: true,
    },
    country: {
        type: String,
        required: true,
    },
    postalCode: { // Optional field
        type: String,
    },
    isVerified: { // To track OTP verification status
        type: Boolean,
        default: false,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    }
});

module.exports = mongoose.model('User', UserSchema); // Capitalized model name
