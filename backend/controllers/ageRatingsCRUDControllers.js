const ageRatingsModel = require('../models/ageRatingsCRUD.js');

module.exports = {
  async getAllAgeRatings(req, res) {
    try {
      const ratings = await ageRatingsModel.getAllAgeRatings();
      res.json(ratings);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить возрастные рейтинги' });
    }
  },

  async getAgeRatingById(req, res) {
    try {
      const rating = await ageRatingsModel.getAgeRatingById(req.params.id);
      if (!rating) return res.status(404).json({ error: 'Возрастной рейтинг не найден' });
      res.json(rating);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить возрастной рейтинг' });
    }
  },

  async createAgeRating(req, res) {
    try {
      const { rating } = req.body; // поле в таблице — rating
      const newRating = await ageRatingsModel.createAgeRating(rating);
      res.status(201).json(newRating);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать возрастной рейтинг' });
    }
  },

  async updateAgeRating(req, res) {
    try {
      const { rating } = req.body;
      const updated = await ageRatingsModel.updateAgeRating(req.params.id, rating);
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить возрастной рейтинг' });
    }
  },

  async deleteAgeRating(req, res) {
    try {
      await ageRatingsModel.deleteAgeRating(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить возрастной рейтинг' });
    }
  },
};
