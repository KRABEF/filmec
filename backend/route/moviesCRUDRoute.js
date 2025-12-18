const express = require('express');
const router = express.Router();
const moviesCtrl = require('../controllers/moviesCRUDControllers.js');

router.get('/', moviesCtrl.getAllMovies);
router.get('/:id', moviesCtrl.getMovieById);
router.post('/', moviesCtrl.createMovie);
router.put('/:id', moviesCtrl.updateMovie);
router.delete('/:id', moviesCtrl.deleteMovie);

module.exports = router;
