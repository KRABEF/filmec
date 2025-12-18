const pool = require('../config/db.js');

module.exports = {
  // Create
  createGenre: async (genreName) => {
    const result = await pool.query('INSERT INTO genre (genres) VALUES ($1) RETURNING *', [
      genreName,
    ]);
    return result.rows[0];
  },

  // Read (Все)
  getAllGenres: async () => {
    const result = await pool.query('SELECT * FROM genre');
    return result.rows;
  },

  // Read (Один)
  getGenreById: async (id) => {
    const result = await pool.query('SELECT * FROM genre WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateGenre: async (id, genreName) => {
    const result = await pool.query('UPDATE genre SET genres = $1 WHERE id = $2 RETURNING *', [
      genreName,
      id,
    ]);
    return result.rows[0];
  },

  // Delete
  deleteGenre: async (id) => {
    await pool.query('DELETE FROM genre WHERE id = $1', [id]);
  },
};
