const pool = require('../config/db.js');

module.exports = {
  // Create
  createFilmTutor: async (name) => {
    const result = await pool.query('INSERT INTO film_tutor (name) VALUES ($1) RETURNING *', [
      name,
    ]);
    return result.rows[0];
  },

  // Read (Все)
  getAllFilmTutors: async () => {
    const result = await pool.query('SELECT * FROM film_tutor');
    return result.rows;
  },

  // Read (Один)
  getFilmTutorById: async (id) => {
    const result = await pool.query('SELECT * FROM film_tutor WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateFilmTutor: async (id, name) => {
    const result = await pool.query('UPDATE film_tutor SET name = $1 WHERE id = $2 RETURNING *', [
      name,
      id,
    ]);
    return result.rows[0];
  },

  // Delete
  deleteFilmTutor: async (id) => {
    await pool.query('DELETE FROM film_tutor WHERE id = $1', [id]);
  },
};
