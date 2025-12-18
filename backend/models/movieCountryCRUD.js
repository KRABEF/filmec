const pool = require('../config/db.js');

module.exports = {
  // Create
  createMovieCountry: async (id_movie, id_country) => {
    const result = await pool.query(
      'INSERT INTO movie_country (id_movie, id_country) VALUES ($1, $2) RETURNING *',
      [id_movie, id_country],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllMovieCountries: async () => {
    const result = await pool.query(`
      SELECT mc.*, m.name AS movie_name, c.country AS country_name
      FROM movie_country mc
      JOIN movie m ON mc.id_movie = m.id
      JOIN countries c ON mc.id_country = c.id
    `);
    return result.rows;
  },

  // Read (Один)
  getMovieCountryById: async (id) => {
    const result = await pool.query(
      `
      SELECT mc.*, m.name AS movie_name, c.country AS country_name
      FROM movie_country mc
      JOIN movie m ON mc.id_movie = m.id
      JOIN countries c ON mc.id_country = c.id
      WHERE mc.id = $1`,
      [id],
    );
    return result.rows[0];
  },

  // Delete
  deleteMovieCountry: async (id) => {
    await pool.query('DELETE FROM movie_country WHERE id = $1', [id]);
  },
};
