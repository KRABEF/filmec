const express = require('express');
const router = express.Router();
const directorMovieCtrl = require('../controllers/directorMovieCRUDControllers.js');

router.get('/', directorMovieCtrl.getAllDirectorMovies);
router.get('/:id', directorMovieCtrl.getDirectorMovieById);
router.post('/', directorMovieCtrl.createDirectorMovie);
router.delete('/:id', directorMovieCtrl.deleteDirectorMovie);

module.exports = router;
