import { DELETE, GET, POST } from './client';

const endpoint = 'api/';

// /create - создание пользователя (почта пароль логин)
export const getGenres = async () => {
  try {
    const response = await GET(`${endpoint}genres`);
    return response.data;
  } catch (err) {
    console.error('Error in getGenres:', err);
    throw err;
  }
};

// /login - вход в аккаунт (логин пароль)
export const userLogin = async (data) => {
  try {
    const response = await POST(`${endpoint}login`, data);
    return response.data;
  } catch (err) {
    console.error('Error in userLogin:', err);
    throw err;
  }
};

// /select - получение всех пользователей
export const userSelect = async () => {
  try {
    const response = await GET(`${endpoint}select`);
    return response.data;
  } catch (err) {
    console.error('Error in userSelect:', err);
    throw err;
  }
};

// /id/:id - получение конкретного пользователя
export const userId = async (id) => {
  try {
    const response = await GET(`${endpoint}id/${id}`);
    return response.data;
  } catch (err) {
    console.error('Error in userId:', err);
    throw err;
  }
};

// /update/:id - обновление информации (смена логина пароля почты фото)
export const userUpdate = async (id, data) => {
  try {
    const response = await POST(`${endpoint}update/${id}`, data);
    return response.data;
  } catch (err) {
    console.error('Error in userUpdate:', err);
    throw err;
  }
};

// /delete/:id - удаление конкретно пользователя
export const userDelete = async (id) => {
  try {
    const response = await DELETE(`${endpoint}delete/${id}`);
    return response.data;
  } catch (err) {
    console.error('Error in userDelete:', err);
    throw err;
  }
};

export const getFilms = async (id) => {
  try {
    const response = await GET(`${endpoint}get/${id}`);
    return response.data;
  } catch (err) {
    console.error('Error in userDelete:', err);
    throw err;
  }
};

// Получение всех возрастных рейтингов (без ID)
export const getAgeRatings = async () => {
  try {
    const response = await GET(`${endpoint}age-ratings`);
    return response.data;
  } catch (err) {
    console.error('Error in getAgeRatings:', err);
    throw err;
  }
};

// Получение конкретного возрастного рейтинга по ID (если нужно)
export const getAgeRatingById = async (id) => {
  try {
    const response = await GET(`${endpoint}age-ratings/${id}`);
    return response.data;
  } catch (err) {
    console.error('Error in getAgeRatingById:', err);
    throw err;
  }
};

// Получение всех стран
export const getCountries = async () => {
  try {
    const response = await GET(`${endpoint}countries`);
    return response.data;
  } catch (err) {
    console.error('Error in getCountries:', err);
    throw err;
  }
};