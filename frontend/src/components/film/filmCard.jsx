import { useState } from 'react';

export const FilmCard = ({ film }) => {
  const [isSaved, setIsSaved] = useState(false);

  return (
    <div className="flex flex-col lg:flex-row gap-8 bg-gradient-to-bl from-neutral-900 to-neutral-900 rounded-xl shadow-lg shadow-orange-700/10 p-6">
      <div className="flex-shrink-0 mx-auto lg:mx-0 ">
        <div className="relative">
          <img
            src={film.poster}
            alt={film.name}
            className="w-64 lg:w-80 object-cover rounded-xl shadow-lg group-hover:shadow-orange-500/30 transition-all duration-300"
          />
          <div className="absolute bottom-0 left-0 right-0 h-20 rounded-b-xl bg-gradient-to-t from-black/60 to-transparent" />
        </div>
      </div>

      <div className="flex-grow">
        <div className="flex flex-col lg:flex-row lg:items-start justify-between">
          <div className="flex-grow lg:mb-4 mb-0 ">
            <div className="flex items-center gap-3 mb-2">
              <h2 className="text-3xl lg:text-4xl font-bold text-white">{film.name}</h2>
              <span className="px-2 py-1 border border-neutral-400 text-neutral-400 text-xs font-bold rounded-md">
                {film.ageLimit}
              </span>
            </div>
            <div className="flex flex-wrap items-center gap-2 text-sm text-gray-300 mb-4">
              <span>{film.release_date}</span>
              <span>{film.duration_movie}</span>
            </div>
          </div>

          <div className="flex gap-3 justify-center">
            <div className="flex items-center justify-center gap-3 bg-neutral-800/50 rounded-xl p-4 min-w-[80px] shadow-lg">
              <div className="text-center">
                <div className="text-2xl font-bold text-orange-500">{film.rating}</div>
                <div className="text-xs text-neutral-400">IMDb</div>
              </div>
            </div>

            <button
              onClick={() => setIsSaved(!isSaved)}
              className="flex items-center justify-center shadow-lg bg-neutral-800/50 rounded-xl p-4 min-w-[80px] hover:bg-neutral-700/50 transition-colors group"
            >
              <div className="text-center">
                {isSaved ? (
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    fill="currentColor"
                    className="bi bi-bookmark-fill text-orange-500 transition-all duration-200"
                    viewBox="0 0 16 16"
                  >
                    <path d="M2 2v13.5a.5.5 0 0 0 .74.439L8 13.069l5.26 2.87A.5.5 0 0 0 14 15.5V2a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2z" />
                  </svg>
                ) : (
                  <svg
                    xmlns="http://www.w3.org/2000/svg"
                    width="20"
                    height="20"
                    fill="currentColor"
                    className="bi bi-bookmark text-neutral-400 group-hover:text-orange-400 transition-all duration-200"
                    viewBox="0 0 16 16"
                  >
                    <path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1z" />
                  </svg>
                )}
              </div>
            </button>
          </div>
        </div>

        <div className="flex flex-col gap-6 mb-6">
          <div className="">
            <h3 className="text-xl font-semibold text-white flex items-center gap-2 my-4">
              О фильме
            </h3>
            <div className="grid grid-cols-1 w-full max-w-md">
              <FilmDetailRow name="Год производства" detail={film.release_date} />
              <FilmDetailRow name="Жанр" detail={film.genres.join(', ')} />
              <FilmDetailRow name="Продолжительность" detail={film.duration_movie} />
            </div>
          </div>

          <div>
            <h4 className="text-xl font-semibold text-white flex items-center gap-2 mb-3">
              Описание
            </h4>
            <div className="relative text-neutral-300">
              <input type="checkbox" id={film.id} className="hidden peer" />
              {film.description.length <= 150 ? (
                <p>{film.description}</p>
              ) : (
                <>
                  <p className="line-clamp-4 peer-checked:line-clamp-none">{film.description}</p>
                  <ToggleLabel
                    id={film.id}
                    labelOff="Подробное описание"
                    labelOn="Свернуть описание"
                  />
                </>
              )}
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

const FilmDetailRow = ({ name, detail }) => {
  return (
    <div className="grid grid-cols-2 gap-2 py-1">
      <span className="text-gray-300 text-sm">{name}</span>
      <span className="text-white font-medium ">{detail}</span>
    </div>
  );
};

const ToggleLabel = ({ id, labelOff, labelOn }) => {
  return (
    <>
      <label
        htmlFor={id}
        className="cursor-pointer text-orange-500 peer-checked:hidden font-medium"
      >
        {labelOff}
      </label>
      <label
        htmlFor={id}
        className="hidden cursor-pointer text-orange-500 peer-checked:block py-1 font-medium"
      >
        {labelOn}
      </label>
    </>
  );
};
