const moviesModel = require('../models/moviesCRUD.js');

module.exports = {
  async getAllMovies(req, res) {
    try {
      const movies = await moviesModel.getAllMovies();
      res.json(movies);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить фильмы' });
    }
  },

  async getMovieById(req, res) {
    try {
      const movie = await moviesModel.getMovieById(req.params.id);
      if (!movie) return res.status(404).json({ error: 'Фильм не найден' });
      res.json(movie);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить фильм' });
    }
  },

  async createMovie(req, res) {
    try {
      const { name, release_date, duration_movie, cover, description, id_age_rating, id_imdb } =
        req.body;
      const newMovie = await moviesModel.createMovie(
        name,
        release_date,
        duration_movie,
        cover,
        description,
        id_age_rating,
        id_imdb,
      );
      res.status(201).json(newMovie);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать фильм' });
    }
  },

  async updateMovie(req, res) {
    try {
      const { name, release_date, duration_movie, cover, description, id_age_rating, id_imdb } =
        req.body;
      const updated = await moviesModel.updateMovie(
        req.params.id,
        name,
        release_date,
        duration_movie,
        cover,
        description,
        id_age_rating,
        id_imdb,
      );
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить фильм' });
    }
  },

  async deleteMovie(req, res) {
    try {
      await moviesModel.deleteMovie(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить фильм' });
    }
  },
};
