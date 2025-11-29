require('dotenv').config();
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DB_URL,
});

(async () => {
  try {
    await pool.query('SELECT 1');
    console.log('БД: Успешное подключение');
  } catch (err) {
    console.error('БД: Ошибка подключения ', err.message);
  }
})();

module.exports = pool;

