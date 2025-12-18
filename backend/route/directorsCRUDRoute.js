const express = require('express');
const router = express.Router();
const directorsCtrl = require('../controllers/directorsCRUDControllers.js');

router.get('/', directorsCtrl.getAllDirectors);
router.get('/:id', directorsCtrl.getDirectorById);
router.post('/', directorsCtrl.createDirector);
router.put('/:id', directorsCtrl.updateDirector);
router.delete('/:id', directorsCtrl.deleteDirector);

module.exports = router;
