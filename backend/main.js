require('dotenv').config();
const express = require('express');
const path = require('path');
const app = express();

const usersRouter = require('./routeUsers/users');

app.use(express.json());
const { authenticateToken, globalGuard } = require('./middlewares/auth');

app.use('/api/users', authenticateToken, globalGuard, usersRouter);

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server is running on port: ${PORT}`));
