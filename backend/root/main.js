require('dotenv').config();
const path = require('path');
const express = require('express');
const cors = require('cors');
const requestLogger = require('../middlewares/requestLogger.js');

const app = express();
const BACK_PORT = process.env.BACK_PORT || 3000;
const FRONT_PORT = process.env.FRONT_PORT || 3001;

corsOptions = {
  origin: `http://localhost:${FRONT_PORT}`,
  credentials: true,
};

app.use(express.json());
app.use(cors(corsOptions));
app.use(requestLogger);

// films
app.use('/api/films', require('../route/filmsRoute.js'));

// users
const { authenticateToken, globalGuard } = require('../middlewares/auth');
app.use('/api/users', authenticateToken, globalGuard, require('../route/usersRoute'));
app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

app.listen(BACK_PORT, () => {
  console.log(`Server is running on port ${BACK_PORT}`);
  console.log(`React is running on port ${FRONT_PORT}`);
});
