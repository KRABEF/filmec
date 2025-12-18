const countriesModel = require('../models/countriesCRUD.js');

module.exports = {
  async getAllCountries(req, res) {
    try {
      const countries = await countriesModel.getAllCountries();
      res.json(countries);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить страны' });
    }
  },

  async getCountryById(req, res) {
    try {
      const country = await countriesModel.getCountryById(req.params.id);
      if (!country) return res.status(404).json({ error: 'Страна не найдена' });
      res.json(country);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось получить страну' });
    }
  },

  async createCountry(req, res) {
    try {
      const { country } = req.body; // поле в таблице — country
      const newCountry = await countriesModel.createCountry(country);
      res.status(201).json(newCountry);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось создать страну' });
    }
  },

  async updateCountry(req, res) {
    try {
      const { country } = req.body;
      const updated = await countriesModel.updateCountry(req.params.id, country);
      res.json(updated);
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось обновить страну' });
    }
  },

  async deleteCountry(req, res) {
    try {
      await countriesModel.deleteCountry(req.params.id);
      res.status(204).end();
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Не удалось удалить страну' });
    }
  },
};
