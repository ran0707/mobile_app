// backend/server.js

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const farmersRoutes = require('./routes/farmersDetails'); // Routes
const logger = require('./logger'); // Logger setup
require('dotenv').config(); // Load environment variables

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors({
    origin: '*', // For development; restrict in production
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

// Routes
app.use('/api/farmers', farmersRoutes);

// Root Route
app.get('/', (req, res) => {
    res.send('<h1>Backend Server is Running</h1>');
});

// Error Handling Middleware (optional, for centralized error handling)
app.use((err, req, res, next) => {
    logger.error(`Unhandled error: ${err.message}`);
    res.status(500).json({ message: 'An unexpected error occurred.' });
});

// MongoDB Connection
mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
})
    .then(() => logger.info('MongoDB connected...'))
    .catch(err => {
        logger.error(`MongoDB connection error: ${err.message}`);
        process.exit(1); // Exit process with failure
    });

// Start Server
app.listen(port, () => {
    logger.info(`Server is running on port ${port}`);
});
