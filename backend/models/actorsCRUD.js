const pool = require('../config/db.js');

module.exports = {
  // Create
  createActor: async (name, surname, photo) => {
    const result = await pool.query(
      'INSERT INTO actor (name, surname, photo) VALUES ($1, $2, $3) RETURNING *',
      [name, surname, photo],
    );
    return result.rows[0];
  },

  // Read (все)
  getAllActors: async () => {
    const result = await pool.query('SELECT * FROM actor');
    return result.rows;
  },

  // Read (один)
  getActorById: async (id) => {
    const result = await pool.query('SELECT * FROM actor WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateActor: async (id, name, surname, photo) => {
    const result = await pool.query(
      'UPDATE actor SET name = $1, surname = $2, photo = $3 WHERE id = $4 RETURNING *',
      [name, surname, photo, id],
    );
    return result.rows[0];
  },

  // Delete
  deleteActor: async (id) => {
    await pool.query('DELETE FROM actor WHERE id = $1', [id]);
  },
};
