const filmTutorsModel = require('../models/filmTutorsCRUD.js');

module.exports = {
  async getAllFilmTutors(req, res) {
    try {
      const tutors = await filmTutorsModel.getAllFilmTutors();
      res.json(tutors);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить дистрибьюторов' });
    }
  },

  async getFilmTutorById(req, res) {
    try {
      const tutor = await filmTutorsModel.getFilmTutorById(req.params.id);
      if (!tutor) return res.status(404).json({ error: 'Дистрибьютор не найден' });
      res.json(tutor);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить дистрибьютора' });
    }
  },

  async createFilmTutor(req, res) {
    try {
      const { name } = req.body;
      const newTutor = await filmTutorsModel.createFilmTutor(name);
      res.status(201).json(newTutor);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать дистрибьютора' });
    }
  },

  async updateFilmTutor(req, res) {
    try {
      const { name } = req.body;
      const updated = await filmTutorsModel.updateFilmTutor(req.params.id, name);
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить дистрибьютора' });
    }
  },

  async deleteFilmTutor(req, res) {
    try {
      await filmTutorsModel.deleteFilmTutor(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить дистрибьютора' });
    }
  },
};
