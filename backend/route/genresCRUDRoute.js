const express = require('express');
const router = express.Router();
const genresCtrl = require('../controllers/genresCRUDControllers.js');

router.get('/', genresCtrl.getAllGenres);
router.get('/:id', genresCtrl.getGenreById);
router.post('/', genresCtrl.createGenre);
router.put('/:id', genresCtrl.updateGenre);
router.delete('/:id', genresCtrl.deleteGenre);

module.exports = router;
