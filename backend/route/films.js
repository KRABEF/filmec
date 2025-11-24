const express = require('express');
const router = express.Router();
const filmsController = require('../controllers/index.js');

// Эндпоинт: GET /api/films
router.get('/', filmsController.getFilms);

module.exports = router;
