// useFilteredFilms.jsx
import { useState, useEffect, useCallback } from 'react';
import { getFilteredFilms } from '../services/filmService';

export const useFilteredFilms = (filters = {}) => {
  const [films, setFilms] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchFilms = useCallback(async () => {
    if (!filters) return;

    setLoading(true);
    setError(null);

    try {
      // Преобразуем фильтры в параметры для API
      const params = {
        genreIds: filters.genres || [],
        actorIds: [],
        directorIds: [],
        countyIds: filters.countryIds || [],
        distributorIds: [],
        years: filters.minYear ? [filters.minYear] : [],
        ageRatingIds: filters.ageRating || [],
        durationMin: 0,
        durationMax: filters.maxDuration || 300,
        sortBy: 'release_date',
        sortOrder: 'desc',
        limit: 50,
        offset: 0,
        minRating: filters.minRating || 0 // Добавляем фильтр по рейтингу
      };

      const data = await getFilteredFilms(params);
      setFilms(data);
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка получения фильмов';
      setError(errMess);
      console.error('Error fetching films:', err);
    } finally {
      setLoading(false);
    }
  }, [filters]);

  useEffect(() => {
    fetchFilms();
  }, [fetchFilms]);

  return { films, loading, error, refetch: fetchFilms };
};