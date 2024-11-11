const express = require('express');
const { sequelize, testConnection, synchronizeDatabase } = require('./app/sequelize');
require('dotenv').config();
const userRoutes = require('./app/routes/userRoutes');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use('/users', userRoutes)

const startServer = async () => {
    try {
        await testConnection();

        await synchronizeDatabase();

        app.listen(PORT, () => {
            console.log(`👻 Server is running on port ${PORT}, Who you gonna call? `);
        });
    } catch (error) {
        console.error('❌ Error initializing the server:', error);
        process.exit(1); 
    }
};

startServer();
