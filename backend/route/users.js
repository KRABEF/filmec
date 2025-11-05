const express =	require('express');
const route = express.Router();
const pool = require('../middlewares/conect');
//проверка существует ли пользователь с таким логином и почтой, если нет то создает пользователя 
route.post('/create', async (req, res) => {
    const { login, email, password } = req.body;

    try {
        const existingUser = await pool.query(
            `SELECT * FROM users WHERE login = $1 OR email = $2`,
            [login, email]
        );

        if (existingUser.rows.length > 0) {
            return res.status(400).json({
                success: false,
                error: 'Login or email already exists'
            });
        }
        await pool.query(
            `INSERT INTO users(login, email, password, registration_date) VALUES($1, $2, $3, NOW())`,
            [login, email, password]
        );

        res.status(201).json({
            success: true,
            message: 'User created successfully'
        });
    } catch (err) {
        console.error(err);
        res.status(500).json({
            success: false,
            error: 'Internal server error'
        });
    }
});

//получение всех пользователей
    route.get('/select', async (req, res) => {
		try {
			const result = await pool.query(`SELECT * FROM users;`);
					res.json(result.rows)
		} catch (err) {
			console.error(err);
			res.sendStatus(500);
		}
	});
//получение конкретного пользователя по id
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

//удаление пользователя по id
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
	
//вход пользователя по логину и поролю
route.post('/login', async (req, res) => {
	try {
		const { login, password } = req.body;

		if (!login || !password) {
			return res.status(400).json({
				success: false,
				error: 'Login and password are required'
			});
		}

		const result = await pool.query(
			`SELECT * FROM users WHERE login = $1 OR email = $1`,
			[login]
		);

		if (result.rows.length === 0) {
			return res.status(401).json({
				success: false,
				error: 'User not found'
			});
		}

		const user = result.rows[0];

		if (user.password !== password) { 
			return res.status(401).json({
				success: false,
				error: 'Invalid password'
			});
		}

		res.json({
			success: true,
			message: 'Login successful',
			user: {
				id: user.id,
				login: user.login,
				email: user.email,
			}
		});
	} catch (err) {
		console.error('Login error:', err);
		res.status(500).json({
			success: false,
			error: 'Internal server error'
		});
	}
});

//редактирование параметров пользователя
route.put('/editing/:id', async (req, res) => {
    try {
        const userId = req.params.id;
        const { login, email, password, photo } = req.body;

        // Проверка наличия хотя бы одного поля
        if (!login && !email && !password && !photo) {
            return res.status(400).json({ error: 'At least one field (login, email, password, or photo) is required' });
        }

        let query = 'UPDATE users SET ';
        const values = [];
        let paramCount = 1;

        // Добавление полей для обновления
        if (login) {
            query += `login = ${paramCount}, `;
            values.push(login);
            paramCount++;
        }
        if (password) {
            query += `password = ${paramCount}, `;
            values.push(password);
            paramCount++;
        }
        if (email) {
            query += `email = ${paramCount}, `;
            values.push(email);
            paramCount++;
        }
        if (photo) {
            query += `photo = ${paramCount}, `;
            values.push(photo);
            paramCount++;
        }

        // Проверка на наличие полей для обновления
        if (values.length === 0) {
            return res.status(400).json({ error: 'No fields to update' });
        }

        // Завершение формирования запроса
        query = query.slice(0, -2) + ` WHERE id = ${paramCount} RETURNING *`;
        values.push(userId);  // userId как последний параметр

        // Отладочная информация
        console.log('Query:', query); // Отладка
        console.log('Values:', values); // Отладка

        const result = await pool.query(query, values);

        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }

        res.json({
            message: 'User updated successfully',
            updatedUser: result.rows[0]
        });
    } catch (err) {
        console.error('Database error:', err);
        res.status(500).json({ error: 'Internal server error' });
    }
});



module.exports = route