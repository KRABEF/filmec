const pool = require('../config/db.js');

module.exports = {
  // Create
  createCountry: async (countryName) => {
    const result = await pool.query('INSERT INTO countries (country) VALUES ($1) RETURNING *', [
      countryName,
    ]);
    return result.rows[0];
  },

  // Read (Все)
  getAllCountries: async () => {
    const result = await pool.query('SELECT * FROM countries');
    return result.rows;
  },

  // Read (Один)
  getCountryById: async (id) => {
    const result = await pool.query('SELECT * FROM countries WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateCountry: async (id, countryName) => {
    const result = await pool.query('UPDATE countries SET country = $1 WHERE id = $2 RETURNING *', [
      countryName,
      id,
    ]);
    return result.rows[0];
  },

  // Delete
  deleteCountry: async (id) => {
    await pool.query('DELETE FROM countries WHERE id = $1', [id]);
  },
};
