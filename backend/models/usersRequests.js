const pool = require('../config/db.js');

const USERS_COLUMNS = 'id, login, email, registration_date, photo';

async function findByLoginOrEmail(loginOrEmail) {
  const { rows } = await pool.query(`SELECT * FROM users WHERE login = $1 OR email = $1`, [
    loginOrEmail,
  ]);
  return rows;
}

async function findByLoginOrEmailExact(login, email) {
  const { rows } = await pool.query(
    `SELECT id, login, email FROM users WHERE login = $1 OR email = $2`,
    [login, email],
  );
  return rows;
}

async function createUser(login, email, hashedPassword) {
  const { rows } = await pool.query(
    `INSERT INTO users (login, email, password, registration_date)
     VALUES ($1, $2, $3, NOW())
     RETURNING id, login, email, registration_date`,
    [login, email, hashedPassword],
  );
  return rows[0];
}

async function findAll() {
  const { rows } = await pool.query(`SELECT ${USERS_COLUMNS} FROM users;`);
  return rows;
}

async function findById(id) {
  const { rows } = await pool.query(`SELECT ${USERS_COLUMNS} FROM users WHERE id = $1;`, [id]);
  return rows[0];
}

async function deleteById(id) {
  const { rows } = await pool.query(`DELETE FROM users WHERE id = $1 RETURNING id, login, email;`, [
    id,
  ]);
  return rows[0];
}

async function findByLoginOrEmailExcludeId(login, email, excludeId) {
  const clauses = [];
  const params = [];
  let idx = 1;

  if (login) {
    clauses.push(`login = $${idx++}`);
    params.push(login);
  }
  if (email) {
    clauses.push(`email = $${idx++}`);
    params.push(email);
  }
  if (clauses.length === 0) return [];

  const sql = `SELECT id, login, email FROM users WHERE (${clauses.join(' OR ')}) AND id <> $${idx}`;
  params.push(excludeId);

  const { rows } = await pool.query(sql, params);
  return rows;
}

async function updateUser(id, updates) {
  const keys = Object.keys(updates);
  if (keys.length === 0) return null;

  const setClauses = [];
  const params = [];
  let idx = 1;
  for (const k of keys) {
    setClauses.push(`${k} = $${idx++}`);
    params.push(updates[k]);
  }
  params.push(id);

  const sql = `UPDATE users SET ${setClauses.join(', ')} WHERE id = $${idx} RETURNING ${USERS_COLUMNS}`;
  const { rows } = await pool.query(sql, params);
  return rows[0];
}
module.exports = {
  findByLoginOrEmail,
  findByLoginOrEmailExact,
  createUser,
  findAll,
  findById,
  deleteById,
  findByLoginOrEmailExcludeId,
  updateUser,
};
