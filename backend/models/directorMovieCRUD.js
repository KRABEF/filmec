const pool = require('../config/db.js');

module.exports = {
  // Create
  createDirectorMovie: async (id_director, id_movie) => {
    const result = await pool.query(
      'INSERT INTO director_movie (id_director, id_movie) VALUES ($1, $2) RETURNING *',
      [id_director, id_movie],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllDirectorMovies: async () => {
    const result = await pool.query(`
      SELECT dm.*, d.name AS director_name, d.surname AS director_surname, m.name AS movie_name
      FROM director_movie dm
      JOIN director d ON dm.id_director = d.id
      JOIN movie m ON dm.id_movie = m.id
    `);
    return result.rows;
  },

  // Read (Один)
  getDirectorMovieById: async (id) => {
    const result = await pool.query(
      `
      SELECT dm.*, d.name AS director_name, d.surname AS director_surname, m.name AS movie_name
      FROM director_movie dm
      JOIN director d ON dm.id_director = d.id
      JOIN movie m ON dm.id_movie = m.id
      WHERE dm.id = $1
    `,
      [id],
    );
    return result.rows[0];
  },

  // Delete
  deleteDirectorMovie: async (id) => {
    await pool.query('DELETE FROM director_movie WHERE id = $1', [id]);
  },
};
