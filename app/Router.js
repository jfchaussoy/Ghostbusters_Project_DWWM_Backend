const express = require('express');
const router = express.Router();

// Importer les différentes routes
const userRoutes = require('./routes/userRoutes');

router.use('/users', userRoutes);

router.use((req, res) => {
  res.status(404).json({ error: 'Route non trouvée' });
});

module.exports = router;
