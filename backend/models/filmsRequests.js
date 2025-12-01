const pool = require('../config/db.js');

module.exports = {
  getFilmsFiltered: async (filters = {}) => {
    const conditions = [];
    const joins = [];
    const params = [];
    let paramIndex = 1;

    // === НАЧАЛО ЗАПРОСА ===
    let sql = `
      SELECT DISTINCT
        m.id,
        m.name,
        m.release_date,
        m.duration_movie,
        m.cover,
        m.description,
        m.id_age_rating,
        m.id_imdb,
        ar.rating AS age_rating
    `;

    sql += `
      FROM movie m
      LEFT JOIN age_rating ar ON m.id_age_rating = ar.id
    `;

    // === ЖАНРЫ ===
    if (filters.genreIds && filters.genreIds.length > 0) {
      joins.push('INNER JOIN movies_genres mg ON m.id = mg.id_movies');
      conditions.push(`mg.id_genres = ANY($${paramIndex}::int[])`);
      params.push(filters.genreIds);
      paramIndex++;
    }

    // === АКТЁРЫ ===
    if (filters.actorIds && filters.actorIds.length > 0) {
      joins.push('INNER JOIN casting ca ON m.id = ca.id_movie');
      conditions.push(`ca.id_actor = ANY($${paramIndex}::int[])`);
      params.push(filters.actorIds);
      paramIndex++;
    }

    // === РЕЖИССЁРЫ ===
    if (filters.directorIds && filters.directorIds.length > 0) {
      joins.push('INNER JOIN director_movie dm ON m.id = dm.id_movie');
      conditions.push(`dm.id_director = ANY($${paramIndex}::int[])`);
      params.push(filters.directorIds);
      paramIndex++;
    }

    // === СТРАНЫ ===
    if (filters.countryIds && filters.countryIds.length > 0) {
      joins.push('INNER JOIN movie_country mc ON m.id = mc.id_movie');
      conditions.push(`mc.id_country = ANY($${paramIndex}::int[])`);
      params.push(filters.countryIds);
      paramIndex++;
    }

    // === ДИСТРИБЬЮТОРЫ ===
    if (filters.distributorIds && filters.distributorIds.length > 0) {
      joins.push('INNER JOIN film_tutor_countries_movie ftcm ON m.id = ftcm.id_movie');
      conditions.push(`ftcm.id_film_tutor = ANY($${paramIndex}::int[])`);
      params.push(filters.distributorIds);
      paramIndex++;
    }

    // === ГОДЫ ===
    if (filters.years && filters.years.length > 0) {
      conditions.push(`EXTRACT(YEAR FROM m.release_date) = ANY($${paramIndex}::int[])`);
      params.push(filters.years);
      paramIndex++;
    }

    // === ВОЗРАСТНОЙ РЕЙТИНГ ===
    if (filters.ageRatingIds && filters.ageRatingIds.length > 0) {
      conditions.push(`m.id_age_rating = ANY($${paramIndex}::int[])`);
      params.push(filters.ageRatingIds);
      paramIndex++;
    }

    // === ПРОДОЛЖИТЕЛЬНОСТЬ ===
    if (filters.durationMin !== undefined || filters.durationMax !== undefined) {
      const minSec = (filters.durationMin || 0) * 60;
      const maxSec = filters.durationMax ? filters.durationMax * 60 : 24 * 3600; // 24 часа
      conditions.push(`
        EXTRACT(EPOCH FROM m.duration_movie) BETWEEN $${paramIndex} AND $${paramIndex + 1}
      `);
      params.push(minSec, maxSec);
      paramIndex += 2;
    }

    // === СБОРКА JOIN'ов ===
    if (joins.length > 0) {
      sql += '\n' + joins.join('\n');
    }

    // === СБОРКА УСЛОВИЙ ===
    if (conditions.length > 0) {
      sql += '\nWHERE ' + conditions.join(' AND ');
    }

    // === СОРТИРОВКА ===
    const sortMap = {
      name: 'm.name',
      release_date: 'm.release_date',
      duration_movie: 'm.duration_movie',
      age_rating: 'm.id_age_rating',
      average_rating: 'average_rating',
    };
    const sortField = sortMap[filters.sortBy] || 'm.name';
    const sortOrder = (filters.sortOrder || 'asc').toLowerCase() === 'desc' ? 'DESC' : 'ASC';
    sql += `\nORDER BY ${sortField} ${sortOrder}`;

    // === ПАГИНАЦИЯ ===
    const limit = Math.min(filters.limit || 20, 100);
    const offset = filters.offset || 0;
    sql += `\nLIMIT $${paramIndex} OFFSET $${paramIndex + 1}`;
    params.push(limit, offset);

    // === ОТЛАДКА ===
    console.log('[DEBUG SQL]:', sql);
    console.log('[DEBUG Params]:', params);

    // === ВЫПОЛНЕНИЕ ===
    const result = await pool.query(sql, params);
    return result.rows;
  },

  // === Получить полную информацию о фильме ===
  getFullMovieById: async (id) => {
    // === Основная информация о фильме ===
    const movieQuery = `
      SELECT
        m.id,
        m.name,
        m.release_date,
        m.duration_movie,
        m.cover,
        m.description,
        m.id_imdb,
        ar.rating AS age_rating
      FROM movie m
      LEFT JOIN age_rating ar ON m.id_age_rating = ar.id
      WHERE m.id = $1
    `;
    const movieResult = await pool.query(movieQuery, [id]);
    const movie = movieResult.rows[0];
    if (!movie) return null;

    // === Жанры ===
    const genresResult = await pool.query(
      `
      SELECT g.genres AS genre
      FROM movies_genres mg
      JOIN genre g ON mg.id_genres = g.id
      WHERE mg.id_movies = $1
    `,
      [id],
    );
    movie.genres = genresResult.rows.map((r) => r.genre);

    // === Актёры ===
    const actorsResult = await pool.query(
      `
      SELECT a.name, a.surname, a.photo
      FROM casting c
      JOIN actor a ON c.id_actor = a.id
      WHERE c.id_movie = $1
    `,
      [id],
    );
    movie.actors = actorsResult.rows;

    // === Режиссёры ===
    const directorsResult = await pool.query(
      `
      SELECT d.name, d.surname, d.photo
      FROM director_movie dm
      JOIN director d ON dm.id_director = d.id
      WHERE dm.id_movie = $1
    `,
      [id],
    );
    movie.directors = directorsResult.rows;

    // === Страны ===
    const countriesResult = await pool.query(
      `
      SELECT c.country
      FROM movie_country mc
      JOIN countries c ON mc.id_country = c.id
      WHERE mc.id_movie = $1
    `,
      [id],
    );
    movie.countries = countriesResult.rows.map((r) => r.country);

    // === Дистрибьюторы ===
    const distributorsResult = await pool.query(
      `
      SELECT ft.name AS distributor
      FROM film_tutor_countries_movie ftcm
      JOIN film_tutor ft ON ftcm.id_film_tutor = ft.id
      WHERE ftcm.id_movie = $1
    `,
      [id],
    );
    movie.distributors = distributorsResult.rows.map((r) => r.distributor);

    return movie;
  },
};
