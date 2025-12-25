import { useState, useEffect } from 'react';
import { ContainerMain } from '../components/containerMain';
import { LeftMenu } from '../components/leftMenu';
import { useFilteredFilms } from '../hooks/useFilteredFilms';

export default function App() {
  const [filters, setFilters] = useState({
    genres: [], // Теперь здесь ID жанров
    minRating: 7,
    ageRating: [],
    minYear: 2025,
    countryIds: [],
    maxDuration: 300,
  });

  const { films, loading, error } = useFilteredFilms(filters);

  const handleFiltersChange = (newFilters) => {
    setFilters(newFilters);
  };

  // Функция для форматирования даты (только год)
  const formatDate = (dateString) => {
    if (!dateString) return '';
    
    try {
      const date = new Date(dateString);
      return date.getFullYear().toString();
    } catch (e) {
      console.error('Error formatting date:', e);
      // Пробуем извлечь год из строки
      const yearMatch = dateString?.match(/\d{4}/);
      return yearMatch ? yearMatch[0] : '';
    }
  };

  // Функция для получения названий жанров из фильма
  const getGenreNamesFromFilm = (film) => {
    if (!film.genres) return [];
    
    // Если жанры - массив строк ["комедия", "ужастик"]
    if (Array.isArray(film.genres) && film.genres.length > 0 && typeof film.genres[0] === 'string') {
      return film.genres;
    }
    
    // Если жанры - массив объектов [{id: 1, name: "комедия"}, ...]
    if (Array.isArray(film.genres) && film.genres.length > 0 && typeof film.genres[0] === 'object') {
      return film.genres
        .map(g => g.name || g.genre_name || g.genres || '')
        .filter(name => name); // Убираем пустые строки
    }
    
    // Если жанры пришли в другом формате
    if (film.genre) {
      return [film.genre];
    }
    
    return [];
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-xl">Загрузка фильмов...</div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="flex items-center justify-center min-h-screen">
        <div className="text-xl text-red-500">Ошибка: {error}</div>
      </div>
    );
  }

  // Преобразуем данные из API в формат для ContainerMain
  const formattedFilms = films.map(film => {
    const genreNames = getGenreNamesFromFilm(film);
    const formattedDate = formatDate(film.release_date);
    console.log(film)
    
    return {
      id: film.id,
      name: film.name || film.title || 'Без названия',
      release_date: formattedDate || film.year || '',
      genres: film.genres,
      duration_movie: film.duration_movie ? `${film.duration_movie} мин` : '0 мин',
      rating: film.rating || film.average_rating || 0,
      ageLimit: film.age_rating || film.age_limit || film.ageLimit || '0+',
      poster: film.cover ,
    };
  });

  return (
    <div className="flex flex-col min-h-screen">
      <main className="flex flex-grow">
        <div className="relative top-0 lg:p-4">
          <LeftMenu onFiltersChange={handleFiltersChange} />
        </div>
        <div className="flex-grow overflow-auto p-4 h-[calc(100vh-100px)]">
          {formattedFilms.length === 0 ? (
            <div className="text-center text-xl mt-10">
              Фильмы не найдены. Попробуйте изменить фильтры.
            </div>
          ) : (
            <ContainerMain movies={formattedFilms} />
          )}
        </div>
      </main>
    </div>
  );
}