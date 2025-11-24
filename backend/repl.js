const repl = require('repl');
require('dotenv').config({ path: './root/.env' });

const pool = require('./config/db');

const replServer = repl.start({
  prompt: 'db> ',
  useColors: true,
});

// Делаем пул доступным в REPL как глобальную переменную
replServer.context.pool = pool;
replServer.context.query = async (text, params = []) => {
  try {
    const start = Date.now();
    const result = await pool.query(text, params);
    const duration = Date.now() - start;
    console.log(`Выполнено за ${duration}ms`);
    console.log('Результат:', result.rows);
    return result.rows;
  } catch (err) {
    console.error('Ошибка:', err.message);
    throw err;
  }
};

console.log('Интерактивная консоль для работы с БД запущена.');
console.log('Используй:');
console.log('  - query("SELECT * FROM movie")');
console.log('  - query("SELECT * FROM movie WHERE year = $1", [2020])');
console.log('  - pool.query(...) — напрямую, если нужно');
console.log('Ctrl+C дважды для выхода.\n');
