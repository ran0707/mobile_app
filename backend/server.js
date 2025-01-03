// backend/server.js

const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
<<<<<<< HEAD
const farmersRoutes = require('./routes/farmersDetails'); // Updated route file
const inferenceRoutes = require('./routes/inference');
const logger = require('./logger'); // Ensure logger is correctly set up
=======
const farmersRoutes = require('./routes/farmersDetails'); // Routes
const logger = require('./logger'); // Logger setup
>>>>>>> f64e27a341bf9e517f75b2522b2e9fb376d9a88d
require('dotenv').config(); // Load environment variables

const app = express();
const port = process.env.PORT || 3000;

// Middleware
app.use(cors({
<<<<<<< HEAD
    origin: '*', // Replace '*' with specific origins in production for better security
=======
    origin: '*', // For development; restrict in production
>>>>>>> f64e27a341bf9e517f75b2522b2e9fb376d9a88d
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization'],
}));
app.use(express.json());

<<<<<<< HEAD
// MongoDB Connection
mongoose.connect(process.env.MONGO_URI, {
    useNewUrlParser: true,
    useUnifiedTopology: true,
    // useCreateIndex: true, // Deprecated in Mongoose 6+
})
    .then(() => logger.info('MongoDB connected...'))
    .catch(err => {
        logger.error(`MongoDB connection error: ${err.message}`);
        process.exit(1); // Exit process with failure
    });

// Routes
app.use('/api/farmers', farmersRoutes); // Updated base path
app.use('api/inference', inferenceRoutes)

// Root Route
app.get('/', (req, res) => {
    res.send('<h1>Server is running using Express</h1>');
});

// Error Handling Middleware
=======
// Routes
app.use('/api/farmers', farmersRoutes);

// Root Route
app.get('/', (req, res) => {
    res.send('<h1>Backend Server is Running</h1>');
});

// Error Handling Middleware (optional, for centralized error handling)
>>>>>>> f64e27a341bf9e517f75b2522b2e9fb376d9a88d
app.use((err, req, res, next) => {
    logger.error(`Unhandled error: ${err.message}`);
    res.status(500).json({ message: 'An unexpected error occurred.' });
});

<<<<<<< HEAD
=======
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

>>>>>>> f64e27a341bf9e517f75b2522b2e9fb376d9a88d
// Start Server
app.listen(port, () => {
    logger.info(`Server is running on port ${port}`);
});
