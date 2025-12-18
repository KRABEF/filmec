const express = require('express');
const router = express.Router();
const moviesGenresCtrl = require('../controllers/movieGenresCRUDControllers.js');

router.get('/', moviesGenresCtrl.getAllMovieGenres);
router.get('/:id', moviesGenresCtrl.getMovieGenreById);
router.post('/', moviesGenresCtrl.createMovieGenre);
router.delete('/:id', moviesGenresCtrl.deleteMovieGenre);

module.exports = router;
