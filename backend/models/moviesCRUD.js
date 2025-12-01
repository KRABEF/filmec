const pool = require('../config/db.js');

module.exports = {
  // Create
  createMovie: async (
    name,
    release_date,
    duration_movie,
    cover,
    description,
    id_age_rating,
    id_imdb,
  ) => {
    const result = await pool.query(
      'INSERT INTO movie (name, release_date, duration_movie, cover, description, id_age_rating, id_imdb) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [name, release_date, duration_movie, cover, description, id_age_rating, id_imdb],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllMovies: async () => {
    const result = await pool.query('SELECT * FROM movie');
    return result.rows;
  },

  // Read (Один)
  getMovieById: async (id) => {
    const result = await pool.query('SELECT * FROM movie WHERE id = $1', [id]);
    return result.rows[0];
  },

  // Update
  updateMovie: async (
    id,
    name,
    release_date,
    duration_movie,
    cover,
    description,
    id_age_rating,
    id_imdb,
  ) => {
    const result = await pool.query(
      'UPDATE movie SET name = $1, release_date = $2, duration_movie = $3, cover = $4, description = $5, id_age_rating = $6, id_imdb = $7 WHERE id = $8 RETURNING *',
      [name, release_date, duration_movie, cover, description, id_age_rating, id_imdb, id],
    );
    return result.rows[0];
  },

  // Delete
  deleteMovie: async (id) => {
    await pool.query('DELETE FROM movie WHERE id = $1', [id]);
  },
};
