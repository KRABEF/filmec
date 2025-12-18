const express = require('express');
const router = express.Router();
const actorsController = require('../controllers/actorsControllers.js');

router.get('/', actorsController.getAllActors);
router.get('/:id', actorsController.getActorById);
router.post('/', actorsController.createActor);
router.put('/:id', actorsController.updateActor);
router.delete('/:id', actorsController.deleteActor);

module.exports = router;
