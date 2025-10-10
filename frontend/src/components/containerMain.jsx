import { useNavigate } from 'react-router-dom';

export const ContainerMain = ({ movies }) => {
  const navigate = useNavigate();
  return (
    // <div className="max-w-full mx-auto py-5 grid gap-5 grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 xl:grid-cols-6">
    <div className="flex flex-wrap justify-between max-w-full mx-auto py-5">
      {movies.map((movie) => (
        <div
          key={movie.id}
          className="flex flex-col bg-neutral-900 rounded-xl shadow-xl hover:shadow-orange-500/10 transition-all duration-300 p-3 group"
        >
          <div className="relative mb-3" onClick={() => navigate(`/movie/${movie.id}`)}>
            <img
              src={movie.poster}
              alt={movie.name}
              className="w-full h-90 object-cover rounded-lg transition-transform duration-500"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/60 via-transparent opacity-0 group-hover:opacity-80 transition-opacity duration-300" />
            <div className="absolute top-3 right-3 bg-orange-500 text-white px-2 py-1 rounded-full text-xs font-medium shadow-lg select-none">
              {movie.rating}
            </div>
            <div className="absolute bottom-1 right-1 bg-neutral-800/80 px-2 py-1 rounded-full text-neutral-300 text-xs font-medium select-none">
              {movie.ageLimit}
            </div>
          </div>

          <div className="cursor-pointer" onClick={() => navigate(`/movie/${movie.id}`)}>
            <h2 className="text-lg font-bold text-white group-hover:text-orange-400 transition-colors duration-300 line-clamp-2">
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
  );
};
