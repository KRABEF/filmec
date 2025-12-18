const pool = require('../config/db.js');

module.exports = {
  // Create
  createCasting: async (id_movie, id_actor) => {
    const result = await pool.query(
      'INSERT INTO casting (id_movie, id_actor) VALUES ($1, $2) RETURNING *',
      [id_movie, id_actor],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllCastings: async () => {
    const result = await pool.query(`
      SELECT c.*, m.name AS movie_name, a.name AS actor_name, a.surname AS actor_surname
      FROM casting c
      JOIN movie m ON c.id_movie = m.id
      JOIN actor a ON c.id_actor = a.id
    `);
    return result.rows;
  },

  // Read (Один)
  getCastingById: async (id) => {
    const result = await pool.query(
      `
      SELECT c.*, m.name AS movie_name, a.name AS actor_name, a.surname AS actor_surname
      FROM casting c
      JOIN movie m ON c.id_movie = m.id
      JOIN actor a ON c.id_actor = a.id
      WHERE c.id = $1
    `,
      [id],
    );
    return result.rows[0];
  },

  // Delete
  deleteCasting: async (id) => {
    await pool.query('DELETE FROM casting WHERE id = $1', [id]);
  },
};
