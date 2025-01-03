// backend/logger.js

const { createLogger, format, transports } = require('winston');
<<<<<<< HEAD
const path = require('path');

const logger = createLogger({
    level: 'info',
    format: format.combine(
        format.timestamp({
            format: 'YYYY-MM-DD HH:mm:ss'
        }),
        format.errors({ stack: true }),
        format.splat(),
        format.json()
    ),
    defaultMeta: { service: 'backend-service' },
    transports: [
        new transports.File({ filename: path.join('logs', 'error.log'), level: 'error' }),
        new transports.File({ filename: path.join('logs', 'combined.log') }),
    ],
});

// If we're not in production then **ALSO** log to the `console`
if (process.env.NODE_ENV !== 'production') {
    logger.add(new transports.Console({
        format: format.combine(
            format.colorize(),
            format.simple()
        )
    }));
}

=======

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

>>>>>>> f64e27a341bf9e517f75b2522b2e9fb376d9a88d
module.exports = logger;
