const express = require('express');
const router = express.Router();
const filmsController = require('../controllers/filmsControllers.js');

router.get('/', filmsController.getFilms);
router.get('/:id/full', filmsController.getFullMovieById);

module.exports = router;
