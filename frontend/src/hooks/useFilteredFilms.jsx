import { useState, useEffect, useCallback } from 'react';
import { getFilteredFilms } from '../services/filmService';

export const useFilteredFilms = (filters = {}) => {
  const [films, setFilms] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchFilms = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const params = new URLSearchParams();

      if (filters.genres?.length > 0) {
        params.append('genreIds', filters.genres.join(','));
      }

      if (filters.years !== undefined && filters.years !== null) {
        params.append('years', filters.years);
      }

      if (filters.durationMax !== undefined) {
        params.append('durationMax', filters.durationMax);
      }
      params.append('durationMin', '0');

      if (filters.minRating !== undefined) {
        params.append('minRating', filters.minRating);
      }

      params.append('sortBy', 'release_date');
      params.append('sortOrder', 'desc');
      params.append('limit', '50');
      params.append('offset', '0');

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
