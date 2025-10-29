const express =	require('express');
const route = express.Router();
const pool = require('../middlewares/conect');

route.post('/create', async (req, res) => {
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

    route.get('/select', async (req, res) => {
		try {
			const result = await pool.query(`SELECT * FROM users;`);
					res.json(result.rows)
		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});

    route.get('/id/:id', async (req, res) => {
		try {
			const userId = req.params.id;
			const result = await pool.query(`SELECT * FROM users WHERE id = $1;`, [userId]);
			if (result.rows.lenght === 0) {
				return res.status(404).json({error: 'not user'});
			}
					res.json(result.rows[0])
		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});


	    route.delete('/deleted/:id', async (req, res) => {
		try {
			const userId = req.params.id;
			const result = await pool.query(`DELETE FROM users WHERE id = $1 RETURNING *;`, [userId]);
			if (result.rows.lenght === 0) {
				return res.status(404).json({error: 'not user'});
			}
					res.json({
						message: 'User deleted',
						deletedUser: result.rows[0]
						
					});
		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});

    route.get('/editing/:id', async (req, res) => {
		try {
			const userId = req.params.id;
			const { login, email, password } = req.body;
			if (!login && !email && !password ) {
				return res.status(404).json({error: 'editing one (login, email or password )'});
			}
				let query = 'UPDATE users set';
			const values = [];
			let paramCount = 1;
			if (login) {
				query += `login = $${paramCount}, `;
				values.push(login);
				paramCount++;
			}
			if (password) {
				query += `password = $${paramCount}, `;
				values.push(password);
				paramCount++;
			}
			if (email) {
				query += `email = $${paramCount}, `;
				values.push(email);
				paramCount++;
			}
			query=query.slice(0,-2) + `WHERE id =$${paramCount} RETURNING *`;
			values.push(userId);

			const result = await pool.query(query, values);

			if (result.rows.length === 0) {
				return res.status(404).json({error: 'User not found'});
			}

			res.json({
				message: 'User updated successfully',
				updatedUser: result.rows[0]
			});

		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});









module.exports = route