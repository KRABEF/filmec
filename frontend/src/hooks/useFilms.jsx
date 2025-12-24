import { useState } from 'react';
import { userSelect, userId, userDelete } from '../services/userService';
import { getGenres } from '../services/filmService';

/**
 * Хук для управления жанрами
 * Методы: 
 */
export const useFilms = () => {
  const [genres_name, setGenres] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const allGenres = async () => {
    setLoading(true);
    setError(null);

    try {
      const genresData = await getGenres();
      console.log(genresData);
      setGenres(genresData);
      return genresData;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка получения жанров';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  return {
    allGenres, 
    genres_name
  };
};
