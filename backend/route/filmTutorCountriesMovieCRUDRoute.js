const express = require('express');
const router = express.Router();
const filmTutorCountriesMovieCtrl = require('../controllers/filmTutorCountriesMovieCRUDControllers.js');

router.get('/', filmTutorCountriesMovieCtrl.getAllFilmTutorCountriesMovies);
router.get('/:id', filmTutorCountriesMovieCtrl.getFilmTutorCountriesMovieById);
router.post('/', filmTutorCountriesMovieCtrl.createFilmTutorCountriesMovie);
router.delete('/:id', filmTutorCountriesMovieCtrl.deleteFilmTutorCountriesMovie);

module.exports = router;
