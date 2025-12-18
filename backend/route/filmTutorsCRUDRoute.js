const express = require('express');
const router = express.Router();
const filmTutorsCtrl = require('../controllers/filmTutorsCRUDControllers.js');

router.get('/', filmTutorsCtrl.getAllFilmTutors);
router.get('/:id', filmTutorsCtrl.getFilmTutorById);
router.post('/', filmTutorsCtrl.createFilmTutor);
router.put('/:id', filmTutorsCtrl.updateFilmTutor);
router.delete('/:id', filmTutorsCtrl.deleteFilmTutor);

module.exports = router;
