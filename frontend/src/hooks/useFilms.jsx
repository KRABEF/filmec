import { useState } from 'react';
import { getGenres } from '../services/filmService';

export const useFilms = () => {
  const [genres_name, setGenres] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const allGenres = async () => {
    setLoading(true);
    setError(null);

    try {
      const genresData = await getGenres();
      console.log('Полученные жанры:', genresData);
      
      // Преобразуем данные к единому формату объектов {id, name}
      const formattedGenres = genresData.map(genre => {
        // Если это строка, например "комедия"
        if (typeof genre === 'string') {
          return { id: genre, name: genre };
        }
        
        // Если это объект с полями id и name
        if (genre.id && genre.name) {
          return { id: genre.id, name: genre.name };
        }
        
        // Если это объект с другими полями
        return {
          id: genre.id || genre.genre_id || genre,
          name: genre.name || genre.genre_name || genre.genres || genre
        };
      });
      
      setGenres(formattedGenres);
      return formattedGenres;
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
    genres_name,
    loading,
    error
  };
};