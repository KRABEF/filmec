require('dotenv').config();

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

app.use('/api/films', require('../route/films.js'));

app.listen(BACK_PORT, () => {
  console.log(`Server is running on port ${BACK_PORT}`);
  console.log(`React is running on port ${FRONT_PORT}`);
});
