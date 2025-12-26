import { useState } from 'react';
import { ContainerMain } from '../components/containerMain';
import { LeftMenu } from '../components/leftMenu';
import { useFilteredFilms } from '../hooks/useFilteredFilms';

export default function App() {
  const [filters, setFilters] = useState({
    genres: [],
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

  // const formatDate = (dateString) => {
  //   if (!dateString) return '';

  //   try {
  //     const date = new Date(dateString);
  //     return date.getFullYear().toString();
  //   } catch (e) {
  //     console.error('Error formatting date:', e);
  //     const yearMatch = dateString?.match(/\d{4}/);
  //     return yearMatch ? yearMatch[0] : '';
  //   }
  // };

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

  const formattedFilms = films.map((film) => {
    // const formattedDate = formatDate(film.release_date);

    return {
      id: film.id,
      name: film.name || film.title || 'Без названия',
      // release_date: formattedDate || film.year || '',
      release_date: film.release_date ? new Date(film.release_date).getFullYear() : 'Не указан',
      genres: film.genres,
      duration_movie: film.duration_movie ? `${film.duration_movie} мин` : '0 мин',
      rating: film.rating || film.average_rating || 0,
      ageLimit: film.age_rating || film.age_limit || film.ageLimit || '0+',
      poster: film.cover,
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
            <div className="text-center text-neutral-400 text-lg italic mt-10">
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
