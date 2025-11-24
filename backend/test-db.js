// test-db.js
require('dotenv').config({ path: './root/.env' });
const pool = require('./config/db');

async function testQuery() {
  try {
    console.log('Подключаюсь к БД...');
    const result = await pool.query('select * from get_movies_by_genres(4)');
    console.log('Запрос выполнен успешно. Получено строк:', result.rows.length);
    console.log('Пример данных:', result.rows[0] || 'Нет данных');
  } catch (err) {
    console.error('Ошибка при выполнении запроса:');
    console.error(err.message);
    console.error(err.stack);
  } finally {
    await pool.end();
  }
}

testQuery();
