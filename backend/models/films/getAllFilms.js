const pool = require('../config/bd.js');

module.exports = {
  getAll: async () => {
    const result = await pool.query('SELECT * FROM movie');
    return result.rows;
  },
};
