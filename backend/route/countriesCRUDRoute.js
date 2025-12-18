const express = require('express');
const router = express.Router();
const countriesCtrl = require('../controllers/countriesCRUDControllers.js');

router.get('/', countriesCtrl.getAllCountries);
router.get('/:id', countriesCtrl.getCountryById);
router.post('/', countriesCtrl.createCountry);
router.put('/:id', countriesCtrl.updateCountry);
router.delete('/:id', countriesCtrl.deleteCountry);

module.exports = router;
