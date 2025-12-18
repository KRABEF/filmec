const pool = require('../config/db.js');

module.exports = {
  // Create
  createMovieGenre: async (id_movies, id_genres) => {
    const result = await pool.query(
      'INSERT INTO movies_genres (id_movies, id_genres) VALUES ($1, $2) RETURNING *',
      [id_movies, id_genres],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllMovieGenres: async () => {
    const result = await pool.query(`
      SELECT mg.*, m.name AS movie_name, g.genres AS genre_name
      FROM movies_genres mg
      JOIN movie m ON mg.id_movies = m.id
      JOIN genre g ON mg.id_genres = g.id
    `);
    return result.rows;
  },

  // Read (Один)
  getMovieGenreById: async (id) => {
    const result = await pool.query(
      `
      SELECT mg.*, m.name AS movie_name, g.genres AS genre_name
      FROM movies_genres mg
      JOIN movie m ON mg.id_movies = m.id
      JOIN genre g ON mg.id_genres = g.id
      WHERE mg.id = $1
    `,
      [id],
    );
    return result.rows[0];
  },

  // Delete
  deleteMovieGenre: async (id) => {
    await pool.query('DELETE FROM movies_genres WHERE id = $1', [id]);
  },
};
