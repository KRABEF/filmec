const pool = require('../config/db.js');

module.exports = {
  // Create
  createDirector: async (name, surname, photo) => {
    const result = await pool.query(
      'INSERT INTO director (name, surname, photo) VALUES ($1, $2, $3) RETURNING *',
      [name, surname, photo],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllDirectors: async () => {
    const result = await pool.query('SELECT * FROM director');
    return result.rows;
  },

  // Read (Один)
  getDirectorById: async (id) => {
    const result = await pool.query('SELECT * FROM director WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateDirector: async (id, name, surname, photo) => {
    const result = await pool.query(
      'UPDATE director SET name = $1, surname = $2, photo = $3 WHERE id = $4 RETURNING *',
      [name, surname, photo, id],
    );
    return result.rows[0];
  },

  // Delete
  deleteDirector: async (id) => {
    await pool.query('DELETE FROM director WHERE id = $1', [id]);
  },
};
