const express =  require('express');
const route = express.Router();
const pool = require('../middlewares/conect');

route.post('/', async (req, res) => {
    const { login, email, password} = req.body;

		try {
			await pool.query(
					`INSERT INTO users(login, email, password, registration_date) VALUES($1, $2, $3, NOW())`,
					[login, email, password]

			);
			res.sendStatus(200);
		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});

    route.get('/', async (req, res) => {
		try {
			const result = await pool.query(`SELECT * FROM users`);
					res.json(result.rows)
		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});

module.exports = route