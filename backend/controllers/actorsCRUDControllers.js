const actorsModel = require('../models/actorsCRUD.js');

module.exports = {
  async getAllActors(req, res) {
    try {
      const actors = await actorsModel.getAllActors();
      res.json(actors);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить актёров' });
    }
  },

  async getActorById(req, res) {
    try {
      const actor = await actorsModel.getActorById(req.params.id);
      if (!actor) return res.status(404).json({ error: 'Актёр не найден' });
      res.json(actor);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить актёра' });
    }
  },

  async createActor(req, res) {
    try {
      const { name, surname, photo } = req.body;
      const newActor = await actorsModel.createActor(name, surname, photo);
      res.status(201).json(newActor);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать актёра' });
    }
  },

  async updateActor(req, res) {
    try {
      const { name, surname, photo } = req.body;
      const updated = await actorsModel.updateActor(req.params.id, name, surname, photo);
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить актёра' });
    }
  },

  async deleteActor(req, res) {
    try {
      await actorsModel.deleteActor(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить актёра' });
    }
  },
};
