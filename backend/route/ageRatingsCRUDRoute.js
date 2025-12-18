const express = require('express');
const router = express.Router();
const ageRatingsCtrl = require('../controllers/ageRatingsCRUDControllers.js');

router.get('/', ageRatingsCtrl.getAllAgeRatings);
router.get('/:id', ageRatingsCtrl.getAgeRatingById);
router.post('/', ageRatingsCtrl.createAgeRating);
router.put('/:id', ageRatingsCtrl.updateAgeRating);
router.delete('/:id', ageRatingsCtrl.deleteAgeRating);

module.exports = router;
