const { Sequelize } = require('sequelize');
require('dotenv').config(); 

const sequelize = new Sequelize(
  process.env.DB_NAME,      
  process.env.DB_USER,       
  process.env.DB_PASSWORD,  
  {
    host: process.env.DB_HOST,  
    dialect: 'postgres',       
    port: process.env.DB_PORT,  
    logging: false,            
  }
);

const testConnection = async () => {
  try {
    await sequelize.authenticate();
    console.log('✅ Connection to the database has been established successfully.');
  } catch (error) {
    console.error('❌ Unable to connect to the database:', error);
    throw error; 
  }
};

const synchronizeDatabase = async () => {
  try {
    await sequelize.sync({ alter: true }); 
    console.log('🔄 Database and tables synchronized successfully!');
  } catch (error) {
    console.error('❌ Error synchronizing database and tables:', error);
    throw error; 
  }
};

module.exports = {
  sequelize,
  testConnection,
  synchronizeDatabase
};
