// backend/models/UserDetails.js

const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const UserSchema = new Schema({
    phone: {
        type: String, // Using String to handle leading zeros
        required: true,
        unique: true,
    },
    name: {
        type: String,
        required: true,
    },
    address: { // User's address
        type: String,
        required: true,
    },
    city: { // User's city
        type: String,
        required: true,
    },
    state: { // User's state
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
    isVerified: { // Tracks OTP verification status
        type: Boolean,
        default: false,
    },
    createdAt: {
        type: Date,
        default: Date.now,
    }
});

module.exports = mongoose.model('User', UserSchema);
