const User = require('../models/user/User');

const userController = {

  createUser: async (req, res) => {
    try {
      const { username, email, password } = req.body;
      const user = await User.create({
        username,
        email,
        password, 
        createdAt: new Date(),
        updatedAt: new Date(),
      });
      res.status(201).json(user);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  getAllUsers: async (req, res) => {
    try {
      const users = await User.findAll();
      res.json(users);
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  getUserById: async (req, res) => {
    try {
      const user = await User.findByPk(req.params.id);
      if (user) {
        res.json(user);
      } else {
        res.status(404).json({ error: 'Utilisateur non trouvé' });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  updateUser: async (req, res) => {
    try {
      const { username, email } = req.body;
      const user = await User.findByPk(req.params.id);
      if (user) {
        user.username = username || user.username;
        user.email = email || user.email;
        user.updatedAt = new Date();
        await user.save();
        res.json(user);
      } else {
        res.status(404).json({ error: 'Utilisateur non trouvé' });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },

  deleteUser: async (req, res) => {
    try {
      const user = await User.findByPk(req.params.id);
      if (user) {
        await user.destroy();
        res.json({ message: 'Utilisateur supprimé avec succès' });
      } else {
        res.status(404).json({ error: 'Utilisateur non trouvé' });
      }
    } catch (error) {
      res.status(500).json({ error: error.message });
    }
  },
};

module.exports = userController;
