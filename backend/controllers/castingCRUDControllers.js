const castingModel = require('../models/castingCRUD.js');

module.exports = {
  async getAllCastings(req, res) {
    try {
      const castings = await castingModel.getAllCastings();
      res.json(castings);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить список актёров в фильмах' });
    }
  },

  async getCastingById(req, res) {
    try {
      const casting = await castingModel.getCastingById(req.params.id);
      if (!casting) return res.status(404).json({ error: 'Связь актёра и фильма не найдена' });
      res.json(casting);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить связь актёра и фильма' });
    }
  },

  async createCasting(req, res) {
    try {
      const { id_movie, id_actor } = req.body;
      const newCasting = await castingModel.createCasting(id_movie, id_actor);
      res.status(201).json(newCasting);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать связь актёра и фильма' });
    }
  },

  async deleteCasting(req, res) {
    try {
      await castingModel.deleteCasting(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить связь актёра и фильма' });
    }
  },
};
