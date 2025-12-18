const pool = require('../config/db.js');

module.exports = {
  // Create
  createFilmTutorCountriesMovie: async (id_film_tutor, id_country, id_movie) => {
    const result = await pool.query(
      'INSERT INTO film_tutor_countries_movie (id_film_tutor, id_country, id_movie) VALUES ($1, $2, $3) RETURNING *',
      [id_film_tutor, id_country, id_movie],
    );
    return result.rows[0];
  },

  // Read (Все)
  getAllFilmTutorCountriesMovies: async () => {
    const result = await pool.query(`
      SELECT ftcm.*, ft.name AS tutor_name, c.country AS country_name, m.name AS movie_name
      FROM film_tutor_countries_movie ftcm
      JOIN film_tutor ft ON ftcm.id_film_tutor = ft.id
      JOIN countries c ON ftcm.id_country = c.id
      JOIN movie m ON ftcm.id_movie = m.id
    `);
    return result.rows;
  },

  // Read (Один)
  getFilmTutorCountriesMovieById: async (id) => {
    const result = await pool.query(
      `
      SELECT ftcm.*, ft.name AS tutor_name, c.country AS country_name, m.name AS movie_name
      FROM film_tutor_countries_movie ftcm
      JOIN film_tutor ft ON ftcm.id_film_tutor = ft.id
      JOIN countries c ON ftcm.id_country = c.id
      JOIN movie m ON ftcm.id_movie = m.id
      WHERE ftcm.id = $1
    `,
      [id],
    );
    return result.rows[0];
  },

  // Delete
  deleteFilmTutorCountriesMovie: async (id) => {
    await pool.query('DELETE FROM film_tutor_countries_movie WHERE id = $1', [id]);
  },
};
