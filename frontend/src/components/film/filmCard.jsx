import { useState } from 'react';
import { Button } from '../ui/button';

export const FilmCard = ({ film }) => {
  const [isSaved, setIsSaved] = useState(false);
  const [isLiked, setIsLiked] = useState(false);

  return (
    <div className="flex flex-col lg:flex-row gap-8 bg-gradient-to-bl from-neutral-200 to-neutral-200 rounded-xl shadow-lg p-6
    dark:from-neutral-900 dark:to-neutral-900
    ">
      <div className="flex-shrink-0 mx-auto lg:mx-0 ">
        <div className="relative">
          <img
            src={film.poster}
            alt={film.name}
            className="w-64 lg:w-80 object-cover rounded-xl shadow-lg group-hover:shadow-orange-500/30 transition-all duration-300"
          />
          <div className="absolute bottom-0 left-0 right-0 h-20 rounded-b-xl bg-gradient-to-t from-black/60 to-transparent" />
        </div>
        <div className="flex gap-1 mt-2">
          <Button onClick={() => setIsLiked(prev => !prev)}>
            <div className="flex items-center justify-center gap-3">
              {!isLiked ? (
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  fill="currentColor"
                  viewBox="0 0 16 16"
                >
                  <path d="m8 2.748-.717-.737C5.6.281 2.514.878 1.4 3.053c-.523 1.023-.641 2.5.314 4.385.92 1.815 2.834 3.989 6.286 6.357 3.452-2.368 5.365-4.542 6.286-6.357.955-1.886.838-3.362.314-4.385C13.486.878 10.4.28 8.717 2.01zM8 15C-7.333 4.868 3.279-3.04 7.824 1.143q.09.083.176.171a3 3 0 0 1 .176-.17C12.72-3.042 23.333 4.867 8 15" />
                </svg>
              ) : (
                <svg
                  xmlns="http://www.w3.org/2000/svg"
                  width="20"
                  height="20"
                  fill="currentColor"
                  viewBox="0 0 16 16"
                >
                  <path
                    fill-rule="evenodd"
                    d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314"
                  />
                </svg>
              )}
              {!isLiked ? 'В Избранное' : 'В Избранном'}
            </div>
          </Button>
          <button
            onClick={() => setIsSaved(prev => !prev)}
            className="flex items-center justify-center shadow-lg dark:bg-neutral-800/80 bg-neutral-300 rounded-xl p-4 min-w-[80px] hover:bg-neutral-400/40 hover:dark:bg-neutral-700/50 transition-colors group"
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
                  className="bi bi-bookmark dark:text-neutral-400 text-neutral-500 group-hover:text-orange-400 transition-all duration-200"
                  viewBox="0 0 16 16"
                >
                  <path d="M2 2a2 2 0 0 1 2-2h8a2 2 0 0 1 2 2v13.5a.5.5 0 0 1-.777.416L8 13.101l-5.223 2.815A.5.5 0 0 1 2 15.5zm2-1a1 1 0 0 0-1 1v12.566l4.723-2.482a.5.5 0 0 1 .554 0L13 14.566V2a1 1 0 0 0-1-1z" />
                </svg>
              )}
            </div>
          </button>
        </div>
      </div>

      <div className="flex-grow">
        <div className="flex flex-col lg:flex-row lg:items-start justify-between">
          <div className="flex items-center gap-3">
            <h2 className="text-3xl lg:text-4xl font-bold">{film.name}</h2>
            <span className="px-2 py-1 border border-neutral-400 text-neutral-400 text-xs font-bold rounded-md">
              {film.ageLimit}
            </span>
          </div>

          <div className="flex gap-3 justify-center my-2 lg:m-0">
            <div className="flex items-center justify-center gap-3 dark:bg-neutral-800/50 bg-neutral-300/50 rounded-xl p-4 min-w-[80px] shadow-lg">
              <div className="text-center">
                <div className="text-2xl font-bold text-orange-500">{film.rating}</div>
                <div className="text-xs text-neutral-400">IMDb</div>
              </div>
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-6 mb-6">
          <div className="">
            <h3 className="text-xl font-semibold flex items-center gap-2 my-4">
              О фильме
            </h3>
            <div className="grid grid-cols-1 w-full max-w-md">
              <FilmDetailRow name="Год производства" detail={film.release_date} />
              <FilmDetailRow name="Жанр" detail={film.genres.join(', ')} />
              <FilmDetailRow name="Продолжительность" detail={film.duration_movie} />
            </div>
          </div>

          <div>
            <h4 className="text-xl font-semibold flex items-center gap-2 mb-3">
              Описание
            </h4>
            <div className="relative dark:text-neutral-300">
              <input type="checkbox" id={film.id} className="hidden peer" />
              {film.description.length <= 200 ? (
                <p>{film.description}</p>
              ) : (
                <>
                  <p className="line-clamp-6 peer-checked:line-clamp-none">{film.description}</p>
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
      <span className="dark:text-gray-300 text-gray-500 text-sm">{name}</span>
      <span className="dark:text-white font-medium ">{detail}</span>
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
