const movieCountryModel = require('../models/movieCountryCRUD.js');

module.exports = {
  async getAllMovieCountries(req, res) {
    try {
      const movieCountries = await movieCountryModel.getAllMovieCountries();
      res.json(movieCountries);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить список стран фильмов' });
    }
  },

  async getMovieCountryById(req, res) {
    try {
      const movieCountry = await movieCountryModel.getMovieCountryById(req.params.id);
      if (!movieCountry) return res.status(404).json({ error: 'Связь фильма и страны не найдена' });
      res.json(movieCountry);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить связь фильма и страны' });
    }
  },

  async createMovieCountry(req, res) {
    try {
      const { id_movie, id_country } = req.body;
      const newMovieCountry = await movieCountryModel.createMovieCountry(id_movie, id_country);
      res.status(201).json(newMovieCountry);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать связь фильма и страны' });
    }
  },

  async deleteMovieCountry(req, res) {
    try {
      await movieCountryModel.deleteMovieCountry(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить связь фильма и страны' });
    }
  },
};
