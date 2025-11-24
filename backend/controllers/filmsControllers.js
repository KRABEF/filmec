const filmsModel = require('../models/filmsRequests.js');

module.exports = {
  getFilms: async (req, res) => {
    try {
      const filters = {};

      // === ПАРСИНГ ПАРАМЕТРОВ ===
      if (req.query.genreIds) {
        filters.genreIds = req.query.genreIds.split(',').map(Number);
      }
      if (req.query.actorIds) {
        filters.actorIds = req.query.actorIds.split(',').map(Number);
      }
      if (req.query.directorIds) {
        filters.directorIds = req.query.directorIds.split(',').map(Number);
      }
      if (req.query.countryIds) {
        filters.countryIds = req.query.countryIds.split(',').map(Number);
      }
      if (req.query.distributorIds) {
        filters.distributorIds = req.query.distributorIds.split(',').map(Number);
      }
      if (req.query.years) {
        filters.years = req.query.years.split(',').map(Number);
      }
      if (req.query.ageRatingIds) {
        filters.ageRatingIds = req.query.ageRatingIds.split(',').map(Number);
      }
      if (req.query.durationMin !== undefined) {
        filters.durationMin = parseInt(req.query.durationMin, 10);
      }
      if (req.query.durationMax !== undefined) {
        filters.durationMax = parseInt(req.query.durationMax, 10);
      }
      filters.sortBy = req.query.sortBy;
      filters.sortOrder = req.query.sortOrder;
      filters.limit = parseInt(req.query.limit, 10);
      filters.offset = parseInt(req.query.offset, 10);

      // === ВЫЗОВ МОДЕЛИ ===
      const films = await filmsModel.getFilmsFiltered(filters);

      res.json(films);
    } catch (err) {
      console.error('Ошибка в getFilms:', err);
      res.status(500).json({ error: 'Не удалось получить фильмы' });
    }
  },
};
