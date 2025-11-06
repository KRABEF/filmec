import { useNavigate } from 'react-router-dom';

export const ContainerMain = ({ movies }) => {
  const navigate = useNavigate();
  return (
    <div className="max-w-full mx-auto lg:max-w-5/6">
      <div className="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-2 xl:grid-cols-3 2xl:grid-cols-4 3xl:grid-cols-5 gap-4 max-w-7xl mx-auto">
        {movies.map((movie) => (
          <div
            key={movie.id}
            className="flex flex-col dark:bg-neutral-900 bg-neutral-50 rounded-xl hover:shadow-2xl shadow-lg hover:shadow-orange-500/30 p-3 group"
          >
            <div className="relative mb-3" onClick={() => navigate(`/movie/${movie.id}`)}>
              <img
                src={movie.poster}
                alt={movie.name}
                className="w-full h-90 object-cover rounded-lg"
              />
              <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent opacity-60" />
              <div className="absolute top-3 right-3 bg-orange-600 text-white px-2 py-1 rounded-full text-xs font-medium shadow-lg select-none">
                {movie.rating}
              </div>
              <div className="absolute bottom-1 right-1 bg-neutral-800/80 px-2 py-1 rounded-full text-neutral-300 text-xs font-medium select-none">
                {movie.ageLimit}
              </div>
            </div>

            <div className="cursor-pointer" onClick={() => navigate(`/movie/${movie.id}`)}>
              <h2 className="text-lg font-bold  line-clamp-2">
                {movie.name}
              </h2>
            </div>

            <div className="flex justify-between items-center">
              <p className="text-neutral-400 text-sm">
                {movie.release_date}, {movie.genres[0]}
              </p>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
};
