const express = require('express');
const router = express.Router();
const castingCtrl = require('../controllers/castingCRUDControllers.js');

router.get('/', castingCtrl.getAllCastings);
router.get('/:id', castingCtrl.getCastingById);
router.post('/', castingCtrl.createCasting);
router.delete('/:id', castingCtrl.deleteCasting);

module.exports = router;
