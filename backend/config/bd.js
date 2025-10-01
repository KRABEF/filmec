require('dotenv').config();

const { Pool } = require('pg');

const pool = new Pool({
	user: proccess.env.DB_USER,
	host: proccess.env.DB_HOST,
	database: process.env.DB_NAME,
	password: process.env.DB_PASSWORD,
	port: proccess.env.DB_PORT,
});
