import { ScrollContainer, ActorCarousel, FilmCard, CommentsFilm } from '../components';
import { useFilm } from '../hooks/useFilm';

export const FilmDetailPage = () => {
  const { film, loading, error } = useFilm();
  console.log(film);
  if (loading) return <div className="p-8 text-center">Загрузка фильма...</div>;
  if (error) return <div className="p-8 text-center text-red-500">Ошибка: {error}</div>;
  if (!film) return <div className="p-8 text-center">Фильм не найден</div>;

  return (
    <ScrollContainer>
      <div className="max-w-6xl mx-auto py-6 space-y-20 px-4">
        <FilmCard film={film} />
        <ActorCarousel film={film} />
        {/* <CommentsFilm /> */}
      </div>
    </ScrollContainer>
  );
};
