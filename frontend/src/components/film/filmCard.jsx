export const FilmCard = ({ film }) => {
  return (
    <div
      className="flex flex-col lg:flex-row gap-8 bg-gradient-to-bl rounded-xl shadow-sm p-6
    dark:from-neutral-900 dark:to-neutral-900
    bg-white
    "
    >
      <div className="flex-shrink-0 mx-auto lg:mx-0 ">
        <div className="relative">
          <img
            src={`/img/resources/movie/${film.cover}`}
            alt={film.name}
            className="w-64 lg:w-80 object-cover rounded-xl shadow-lg group-hover:shadow-orange-500/30"
          />
          <div className="absolute bottom-0 left-0 right-0 h-20 rounded-b-xl bg-gradient-to-t from-black/60 to-transparent" />
        </div>
      </div>

      <div className="flex-grow">
        <div className="flex flex-col lg:flex-row lg:items-start justify-between">
          <div className="flex items-center gap-3">
            <h2 className="text-3xl lg:text-4xl font-bold">{film.name}</h2>
            <span className="px-2 py-1 border border-neutral-400 text-neutral-400 text-xs font-bold rounded-md">
              {film.age_rating}
            </span>
          </div>
        </div>

        <div className="flex flex-col gap-6 mb-6">
          <div className="">
            <h3 className="text-xl font-semibold flex items-center gap-2 my-4">О фильме</h3>
            <div className="grid grid-cols-1 w-full">
              <FilmDetailRow
                name="Год производства"
                detail={film.release_date ? new Date(film.release_date).getFullYear() : 'Не указан'}
              />
              <FilmDetailRow name="Жанр" detail={film.genres.join(', ')} />
              <FilmDetailRow name="Продолжительность" detail={film.duration_movie} />
            </div>
          </div>

          <div>
            <h4 className="text-xl font-semibold flex items-center gap-2 mb-3">Описание</h4>
            <div className="relative dark:text-neutral-300">
              <input type="checkbox" id={film.id} className="hidden peer" />
              {film.description.length <= 450 ? (
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
    <div className="grid md:grid-cols-[200px_1fr] gap-2 py-1">
      <span className="dark:text-gray-400 text-gray-700 text-sm">{name}</span>
      <span className=" font-medium ">{detail}</span>
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
