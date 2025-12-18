const directorsModel = require('../models/directorsCRUD.js');

module.exports = {
  async getAllDirectors(req, res) {
    try {
      const directors = await directorsModel.getAllDirectors();
      res.json(directors);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить режиссёров' });
    }
  },

  async getDirectorById(req, res) {
    try {
      const director = await directorsModel.getDirectorById(req.params.id);
      if (!director) return res.status(404).json({ error: 'Режиссёр не найден' });
      res.json(director);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить режиссёра' });
    }
  },

  async createDirector(req, res) {
    try {
      const { name, surname, photo } = req.body;
      const newDirector = await directorsModel.createDirector(name, surname, photo);
      res.status(201).json(newDirector);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать режиссёра' });
    }
  },

  async updateDirector(req, res) {
    try {
      const { name, surname, photo } = req.body;
      const updated = await directorsModel.updateDirector(req.params.id, name, surname, photo);
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить режиссёра' });
    }
  },

  async deleteDirector(req, res) {
    try {
      await directorsModel.deleteDirector(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить режиссёра' });
    }
  },
};
