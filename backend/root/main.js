const path = require('path');

require('dotenv').config({ path: './root/.env' });

const express = require('express');
const cors = require('cors');
const requestLogger = require('../middlewares/requestLogger.js');

const app = express();
const BACK_PORT = process.env.BACK_PORT || 5075;
const FRONT_PORT = process.env.FRONT_PORT || 5173;

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

// CRUD
app.use('/api/directors', require('../route/directorsCRUDRoute.js'));
app.use('/api/genres', require('../route/genresCRUDRoute.js'));
app.use('/api/countries', require('../route/countriesCRUDRoute.js'));
app.use('/api/film-tutors', require('../route/filmTutorsCRUDRoute.js'));
app.use('/api/age-ratings', require('../route/ageRatingsCRUDRoute.js'));
app.use('/api/movies', require('../route/moviesCRUDRoute.js'));
app.use('/api/castings', require('../route/castingCRUDRoute.js'));
app.use('/api/director-movies', require('../route/directorMovieCRUDRoute.js'));
app.use('/api/movie-countries', require('../route/movieCountryCRUDRoute.js'));
app.use('/api/movie-genres', require('../route/movieGenresCRUDRoute.js'));
app.use(
  '/api/film-tutor-countries-movies',
  require('../route/filmTutorCountriesMovieCRUDRoute.js'),
);

app.listen(BACK_PORT, () => {
  console.log(`Server is running on port ${BACK_PORT}`);
  console.log(`React is running on port ${FRONT_PORT}`);
});
