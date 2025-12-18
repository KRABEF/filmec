const filmTutorCountriesMovieModel = require('../models/filmTutorCountriesMovieCRUD.js');

module.exports = {
  async getAllFilmTutorCountriesMovies(req, res) {
    try {
      const records = await filmTutorCountriesMovieModel.getAllFilmTutorCountriesMovies();
      res.json(records);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить список дистрибьюторов, стран и фильмов' });
    }
  },

  async getFilmTutorCountriesMovieById(req, res) {
    try {
      const record = await filmTutorCountriesMovieModel.getFilmTutorCountriesMovieById(
        req.params.id,
      );
      if (!record)
        return res.status(404).json({ error: 'Запись дистрибьютора, страны и фильма не найдена' });
      res.json(record);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить запись дистрибьютора, страны и фильма' });
    }
  },

  async createFilmTutorCountriesMovie(req, res) {
    try {
      const { id_film_tutor, id_country, id_movie } = req.body;
      const newRecord = await filmTutorCountriesMovieModel.createFilmTutorCountriesMovie(
        id_film_tutor,
        id_country,
        id_movie,
      );
      res.status(201).json(newRecord);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать запись дистрибьютора, страны и фильма' });
    }
  },

  async deleteFilmTutorCountriesMovie(req, res) {
    try {
      await filmTutorCountriesMovieModel.deleteFilmTutorCountriesMovie(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить запись дистрибьютора, страны и фильма' });
    }
  },
};
