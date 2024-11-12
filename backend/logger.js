// backend/logger.js

const { createLogger, format, transports } = require('winston');

const logger = createLogger({
    level: 'info', // Adjust log level as needed
    format: format.combine(
        format.timestamp(),
        format.printf(({ timestamp, level, message }) => `${timestamp} [${level.toUpperCase()}]: ${message}`)
    ),
    transports: [
        new transports.Console(),
        // Optionally add file transports:
        // new transports.File({ filename: 'error.log', level: 'error' }),
        // new transports.File({ filename: 'combined.log' }),
    ],
});

module.exports = logger;
