const moviesGenresModel = require('../models/movieGenresCRUD.js');

module.exports = {
  async getAllMovieGenres(req, res) {
    try {
      const movieGenres = await moviesGenresModel.getAllMovieGenres();
      res.json(movieGenres);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить список жанров фильмов' });
    }
  },

  async getMovieGenreById(req, res) {
    try {
      const movieGenre = await moviesGenresModel.getMovieGenreById(req.params.id);
      if (!movieGenre) return res.status(404).json({ error: 'Связь фильма и жанра не найдена' });
      res.json(movieGenre);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить связь фильма и жанра' });
    }
  },

  async createMovieGenre(req, res) {
    try {
      const { id_movies, id_genres } = req.body;
      const newMovieGenre = await moviesGenresModel.createMovieGenre(id_movies, id_genres);
      res.status(201).json(newMovieGenre);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать связь фильма и жанра' });
    }
  },

  async deleteMovieGenre(req, res) {
    try {
      await moviesGenresModel.deleteMovieGenre(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить связь фильма и жанра' });
    }
  },
};
