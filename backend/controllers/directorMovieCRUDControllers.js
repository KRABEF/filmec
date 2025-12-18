const directorMovieModel = require('../models/directorMovieCRUD.js');

module.exports = {
  async getAllDirectorMovies(req, res) {
    try {
      const directorMovies = await directorMovieModel.getAllDirectorMovies();
      res.json(directorMovies);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить список режиссёров в фильмах' });
    }
  },

  async getDirectorMovieById(req, res) {
    try {
      const directorMovie = await directorMovieModel.getDirectorMovieById(req.params.id);
      if (!directorMovie)
        return res.status(404).json({ error: 'Связь режиссёра и фильма не найдена' });
      res.json(directorMovie);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить связь режиссёра и фильма' });
    }
  },

  async createDirectorMovie(req, res) {
    try {
      const { id_director, id_movie } = req.body;
      const newDirectorMovie = await directorMovieModel.createDirectorMovie(id_director, id_movie);
      res.status(201).json(newDirectorMovie);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать связь режиссёра и фильма' });
    }
  },

  async deleteDirectorMovie(req, res) {
    try {
      await directorMovieModel.deleteDirectorMovie(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить связь режиссёра и фильма' });
    }
  },
};
