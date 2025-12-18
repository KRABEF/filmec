const pool = require('../config/db.js');

module.exports = {
  // Create
  createAgeRating: async (rating) => {
    const result = await pool.query('INSERT INTO age_rating (rating) VALUES ($1) RETURNING *', [
      rating,
    ]);
    return result.rows[0];
  },

  // Read (Все)
  getAllAgeRatings: async () => {
    const result = await pool.query('SELECT * FROM age_rating');
    return result.rows;
  },

  // Read (Один)
  getAgeRatingById: async (id) => {
    const result = await pool.query('SELECT * FROM age_rating WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateAgeRating: async (id, rating) => {
    const result = await pool.query('UPDATE age_rating SET rating = $1 WHERE id = $2 RETURNING *', [
      rating,
      id,
    ]);
    return result.rows[0];
  },

  // Delete
  deleteAgeRating: async (id) => {
    await pool.query('DELETE FROM age_rating WHERE id = $1', [id]);
  },
};
