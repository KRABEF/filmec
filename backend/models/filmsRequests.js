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
};
