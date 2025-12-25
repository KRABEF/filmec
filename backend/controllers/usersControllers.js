const bcrypt = require('bcrypt');
const usersModel = require('../models/usersRequests');
const jwt = require('jsonwebtoken');
const JWT_SECRET = process.env.JWT_SECRET;
const JWT_EXPIRES = process.env.JWT_EXPIRES || '8h';
const SALT_ROUNDS = 10;

async function create(req, res) {
  try {
    const { login, email, password } = req.body;
    if (!login || !email || !password) {
      return res.status(400).json({ success: false, error: 'требуется: логин, почта и пароль' });
    }

    const existing = await usersModel.findByLoginOrEmailExact(login, email);
    if (existing.length > 0) {
      return res.status(400).json({ success: false, error: 'логин или пароль уже существует' });
    }

    const hashed = await bcrypt.hash(password, SALT_ROUNDS);
    const user = await usersModel.createUser(login, email, hashed);

     const payload = {
      id: user.id,
      login: user.login,
      role: user.role || 'user'
    };

    const token = jwt.sign(payload, JWT_SECRET, { expiresIn: JWT_EXPIRES })

    return res.status(201).json({
      success: true,
      message: 'User created',
      token, 
      user: {
        id: user.id,
        login: user.login,
        email: user.email,
        role: payload.role,
        registration_date: user.registration_date
      }
    });
  } catch (err) {
    console.error('create controller error:', err);
    return res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
}

async function selectAll(req, res) {
  try {
    const users = await usersModel.findAll();
    return res.json({ success: true, users });
  } catch (err) {
    console.error('selectAll error:', err);
    return res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
}

async function getById(req, res) {
  try {
    const userId = req.params.id;
    const user = await usersModel.findById(userId);
    if (!user) {
      return res.status(404).json({ success: false, error: 'Пользователь не найден' });
    }
    return res.json({ success: true, user });
  } catch (err) {
    console.error('getById error:', err);
    return res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
}

async function removeById(req, res) {
  try {
    const userId = String(req.params.id);

    if (!req.user) {
      return res.status(401).json({ success: false, error: 'Не аутентифицирован' });
    }

    const isAdmin = String(req.user.role) === 'admin';
    const isOwner = String(req.user.id) === userId;

    if (!isAdmin && !isOwner) {
      return res.status(403).json({ success: false, error: 'Forbidden' });
    }

    const deleted = await usersModel.deleteById(userId);
    if (!deleted) {
      return res.status(404).json({ success: false, error: 'Пользователь не найден' });
    }

    return res.json({ success: true, message: 'User deleted', deletedUser: deleted });
  } catch (err) {
    console.error('removeById error:', err);
    return res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
}

async function login(req, res) {
  try {
    const { login, password } = req.body;
    if (!login || !password) {
      return res.status(400).json({ success: false, error: 'Требуется логин и пароль' });
    }

    const rows = await usersModel.findByLoginOrEmail(login);
    if (!rows || rows.length === 0) {
      return res.status(401).json({ success: false, error: 'Пользователь не найден' });
    }

    const user = rows[0];

    const match = await bcrypt.compare(password, user.password);
    if (!match) {
      return res.status(401).json({ success: false, error: 'Неверный пароль' });
    }

    const payload = {
      id: user.id,
      login: user.login,
      role: user.role || 'user',
    };

    const token = jwt.sign(payload, JWT_SECRET, {
      expiresIn: JWT_EXPIRES,
    });

    const publicUser = {
      id: user.id,
      login: user.login,
      photo: user.photo,
      email: user.email,
      role: payload.role,
      registration_date: user.registration_date
    };

    return res.json({
      success: true,
      message: 'Login successful',
      token,
      user: publicUser,
    });
  } catch (err) {
    console.error('login controller error:', err);
    return res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
}

async function update(req, res) {
  try {
    const userId = req.params.id;
    if (!userId) return res.status(400).json({ success: false, error: 'Требуется id пользователя' });

    const { login, email, password, photo } = req.body;
    const photoFile = req.file;

    if (login || email) {
      const conflict = await usersModel.findByLoginOrEmailExcludeId(
        login || null,
        email || null,
        userId,
      );
      if (conflict && conflict.length > 0) {
        return res
          .status(400)
          .json({ success: false, error: 'Логин или почта уже используются другим пользователем' });
      }
    }

    const updates = {};
    if (login) updates.login = login;
    if (email) updates.email = email;
    if (password) {
      const hashed = await bcrypt.hash(String(password), SALT_ROUNDS);
      updates.password = hashed;
    }

    if (photoFile) {
      updates.photo = `/uploads/${photoFile.filename}`;
    } else if (photo) {
      updates.photo = String(photo);
    }

    if (Object.keys(updates).length === 0) {
      return res.status(400).json({ success: false, error: 'Нет полей для обновления' });
    }

    const updated = await usersModel.updateUser(userId, updates);
    if (!updated) return res.status(404).json({ success: false, error: 'Пользователь не найден' });

    const publicUser = {
      id: updated.id,
      login: updated.login,
      email: updated.email,
      registration_date: updated.registration_date,
      photo: updated.photo || null,
    };

    return res.json({ success: true, user: publicUser });
  } catch (err) {
    console.error('update controller error:', err);
    return res.status(500).json({ success: false, error: 'Внутренняя ошибка сервера' });
  }
}

module.exports = {
  create,
  selectAll,
  getById,
  removeById,
  login,
  update,
};
