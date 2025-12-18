const express = require('express');
const router = express.Router();
const movieCountryCtrl = require('../controllers/movieCountryCRUDControllers.js');

router.get('/', movieCountryCtrl.getAllMovieCountries);
router.get('/:id', movieCountryCtrl.getMovieCountryById);
router.post('/', movieCountryCtrl.createMovieCountry);
router.delete('/:id', movieCountryCtrl.deleteMovieCountry);

module.exports = router;
