import { useState, useEffect } from 'react';
import { useParams } from 'react-router-dom';
import { filmId } from '../services/filmIdService';

export const useFilm = () => {
  const [film, setFilm] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const { id } = useParams();

  useEffect(() => {
    if (id) {
      getFilmId(id);
    }
  }, [id]);

  const getFilmId = async (id) => {
    setLoading(true);
    setError(null);

    try {
      const data = await filmId(id);
      setFilm(data);
      return data;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка получения фильма';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  return {
    film,
    loading,
    error,
    getFilmId,
    refetch: () => id && getFilmId(id),
  };
};
