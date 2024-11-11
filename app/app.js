const express = require('express');
const cors = require('cors');
const morgan = require('morgan');

const app = express();

app.use(express.json());
app.use(cors());
app.use(morgan('dev'));

const userRoutes = require('./routes/userRoutes');

app.use('/users', userRoutes);

app.get('/', (req, res) => {
  res.send('Welcome to API Ghostbusters !');
});

app.use((req, res) => {
  res.status(404).json({ error: 'Route non trouvée' });
});

module.exports = app;
