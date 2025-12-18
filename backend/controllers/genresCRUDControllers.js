const genresModel = require('../models/genresCRUD.js');

module.exports = {
  async getAllGenres(req, res) {
    try {
      const genres = await genresModel.getAllGenres();
      res.json(genres);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить жанры' });
    }
  },

  async getGenreById(req, res) {
    try {
      const genre = await genresModel.getGenreById(req.params.id);
      if (!genre) return res.status(404).json({ error: 'Жанр не найден' });
      res.json(genre);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить жанр' });
    }
  },

  async createGenre(req, res) {
    try {
      const { genres } = req.body;
      const newGenre = await genresModel.createGenre(genres);
      res.status(201).json(newGenre);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать жанр' });
    }
  },

  async updateGenre(req, res) {
    try {
      const { genres } = req.body;
      const updated = await genresModel.updateGenre(req.params.id, genres);
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить жанр' });
    }
  },

  async deleteGenre(req, res) {
    try {
      await genresModel.deleteGenre(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить жанр' });
    }
  },
};
