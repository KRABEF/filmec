import React, { useEffect, useState } from 'react';
import { Button } from '../components/ui/button';
import { useFilms } from '../hooks/useFilms';

export const LeftMenu = ({ onFiltersChange }) => {
  const { allGenres, genres_name } = useFilms();
  const [isDurationOpen, setIsDurationOpen] = useState(window.innerWidth >= 1024);

  useEffect(() => {
    allGenres();
  }, []);

  const [draftFilters, setDraftFilters] = useState({
    genres: [],
    minRating: 7,
    ageRating: [],
    years: null,
    countryIds: [],
    maxDuration: 300,
  });

  const [isGenresOpen, setIsGenresOpen] = useState(false);
  const [isYearOpen, setIsYearOpen] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const handleGenreToggle = (genreId) => {
    const newGenres = draftFilters.genres.includes(genreId)
      ? draftFilters.genres.filter((id) => id !== genreId)
      : [...draftFilters.genres, genreId];

    setDraftFilters({ ...draftFilters, genres: newGenres });
  };

  const handleYearChange = (value) => {
    setDraftFilters({
      ...draftFilters,
      years: value === '' ? null : +value,
    });
  };

  const applyFilters = () => {
    const apiFilters = {
      genres: draftFilters.genres,
      minRating: draftFilters.minRating,
      durationMax: draftFilters.maxDuration,
      ...(draftFilters.years !== null && { years: draftFilters.years }),
    };

    onFiltersChange?.(apiFilters);

    if (window.innerWidth < 1024) {
      setIsMenuOpen(false);
    }
  };

  const resetFilters = () => {
    const defaults = {
      genres: [],
      minRating: 7,
      ageRating: [],
      years: null,
      countryIds: [],
      maxDuration: 300,
    };
    setDraftFilters(defaults);

    onFiltersChange?.({});
  };

  return (
    <>
      {/* Мобильная кнопка */}
      <div className="lg:hidden fixed top-26 left-2 z-50">
        <Button
          onClick={() => setIsMenuOpen(!isMenuOpen)}
          className="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg shadow-lg"
        >
          ☰ Фильтры
        </Button>
      </div>

      {/* Оверлей */}
      {isMenuOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/70 z-40"
          onClick={() => setIsMenuOpen(false)}
        />
      )}

      {/* МОБИЛЬНОЕ МЕНЮ */}
      <div
        className={`lg:hidden fixed left-0 top-0 h-full w-80 bg-neutral-900 rounded-r-lg p-6 border-r border-neutral-800 transform z-1000 overflow-y-auto ${
          isMenuOpen ? 'translate-x-0' : '-translate-x-full'
        }`}
      >
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-xl font-bold text-white">Фильтры</h1>
          <button
            onClick={() => setIsMenuOpen(false)}
            className="text-neutral-400 hover:text-white text-2xl"
          >
            ✕
          </button>
        </div>

        {/* ЖАНРЫ */}
        <div className="mb-6">
          <button
            onClick={() => setIsGenresOpen(!isGenresOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h2 className="text-lg font-semibold text-white">
              Жанры ({draftFilters.genres.length})
            </h2>
            <span className="text-neutral-400 text-xl">{isGenresOpen ? '−' : '+'}</span>
          </button>
          {isGenresOpen && (
            <div className="mt-2 space-y-3 pl-2">
              {genres_name.map((genre) => {
                const genreId = typeof genre === 'object' ? genre.id : genre;
                const genreName = typeof genre === 'object' ? genre.name || genre.genres : genre;
                return (
                  <label key={genreId} className="flex items-center space-x-3 cursor-pointer py-2">
                    <input
                      type="checkbox"
                      checked={draftFilters.genres.includes(genreId)}
                      onChange={() => handleGenreToggle(genreId)}
                      className="w-5 h-5 accent-orange-500 check"
                    />
                    <span className="text-neutral-300 hover:text-white text-base">{genreName}</span>
                  </label>
                );
              })}
            </div>
          )}
        </div>

        {/* ГОД - МОБИЛЬНАЯ ВЕРСИЯ */}
        <div className="mb-6">
          <button
            onClick={() => setIsYearOpen(!isYearOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h2 className="text-lg font-semibold text-white">
              Год {draftFilters.years ? `(${draftFilters.years})` : ''}
            </h2>
            <span className="text-neutral-400 text-xl">{isYearOpen ? '−' : '+'}</span>
          </button>
          {isYearOpen && (
            <div className="mt-2 pl-2">
              <input
                type="number"
                min="1900"
                max="2025"
                value={draftFilters.years || ''}
                onChange={(e) => handleYearChange(e.target.value)}
                placeholder="2025"
                className="w-full px-3 py-2 border border-neutral-600 rounded-lg bg-neutral-800 text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
              />
            </div>
          )}
        </div>

        {/* КНОПКИ */}
        <div className="flex flex-col space-y-3 mt-8">
          <Button
            onClick={applyFilters}
            className="w-full bg-orange-500 hover:bg-orange-600 text-white py-3 text-base font-semibold"
          >
            Применить фильтры
          </Button>
          <Button
            onClick={resetFilters}
            variant="outline"
            className="w-full border-neutral-600 text-neutral-300 hover:bg-neutral-800 py-3 text-base"
          >
            Сбросить фильтры
          </Button>
        </div>
      </div>

      {/* ДЕСКТОП МЕНЮ */}
      <div className="hidden shadow-xs lg:flex flex-col w-80 max-h-[calc(100vh-120px)] dark:bg-neutral-900 bg-white rounded-lg p-6">
        <div className="flex-1 min-h-0 overflow-y-auto pr-2 mb-4">
          {/* ЖАНРЫ */}
          <div className="mb-6">
            <button
              onClick={() => setIsGenresOpen(!isGenresOpen)}
              className="flex justify-between items-center w-full text-left hover:bg-transparent"
            >
              <h2 className="text-xl font-bold dark:text-white text-neutral-900">
                Жанры ({draftFilters.genres.length})
              </h2>
              <span className="text-neutral-400">{isGenresOpen ? '−' : '+'}</span>
            </button>
            {isGenresOpen && (
              <div className="mt-4 space-y-2">
                {genres_name.map((genre) => {
                  const genreId = typeof genre === 'object' ? genre.id : genre;
                  const genreName = typeof genre === 'object' ? genre.name || genre.genres : genre;
                  return (
                    <label
                      key={genreId}
                      className="flex items-center space-x-3 cursor-pointer hover:bg-neutral-100 dark:hover:bg-neutral-800 px-2 py-1 rounded transition-colors"
                    >
                      <input
                        type="checkbox"
                        checked={draftFilters.genres.includes(genreId)}
                        onChange={() => handleGenreToggle(genreId)}
                        className="w-4 h-4 accent-orange-500 check"
                      />
                      <span className="text-neutral-800 hover:text-black dark:text-neutral-300 dark:hover:text-white">
                        {genreName}
                      </span>
                    </label>
                  );
                })}
              </div>
            )}
          </div>

          {/* ГОД - ДЕСКТОП */}
          <div className="mb-6">
            <button
              onClick={() => setIsYearOpen(!isYearOpen)}
              className="flex justify-between items-center w-full text-left py-3 hover:bg-transparent"
            >
              <h2 className="text-xl font-bold dark:text-white text-neutral-900">
                Год {draftFilters.years ? `(${draftFilters.years})` : ''}
              </h2>
              <span className="text-neutral-400">{isYearOpen ? '−' : '+'}</span>
            </button>
            {isYearOpen && (
              <div className="mt-4 pl-2">
                <input
                  type="number"
                  min="1900"
                  max="2025"
                  value={draftFilters.years || ''}
                  onChange={(e) => handleYearChange(e.target.value)}
                  placeholder="2025"
                  className="w-full px-3 py-2 border border-neutral-300 dark:border-neutral-600 rounded-lg bg-white dark:bg-neutral-800 text-neutral-900 dark:text-white focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                />
              </div>
            )}
          </div>

          {/* Длительность */}
          <div className="mb-6">
            <button
              onClick={() => setIsDurationOpen(!isDurationOpen)}
              className="flex justify-between items-center w-full text-left py-3"
            >
              <h2 className="text-lg font-semibold text-white">
                Длительность до {draftFilters.maxDuration} мин
              </h2>
              <span className="text-neutral-400 text-xl">{isDurationOpen ? '−' : '+'}</span>
            </button>

            {isDurationOpen && (
              <div className="mt-4 pl-2">
                <input
                  type="range"
                  min="0"
                  max="300"
                  value={draftFilters.maxDuration}
                  onChange={(e) =>
                    setDraftFilters({ ...draftFilters, maxDuration: +e.target.value })
                  }
                  className="w-full h-2 bg-neutral-700 rounded-full cursor-pointer accent-orange-500"
                />
                <div className="flex justify-between mt-2 text-sm text-neutral-400">
                  <span>0</span>
                  <span>300+ мин</span>
                </div>
              </div>
            )}
          </div>
        </div>

        <div className="pt-4 border-t border-neutral-300 dark:border-neutral-800 space-y-3">
          <Button
            onClick={applyFilters}
            className="w-full rounded-lg bg-orange-500 hover:bg-orange-600 text-white py-2.5 font-medium"
          >
            Найти
          </Button>

          <Button
            onClick={resetFilters}
            className="w-full rounded-lg bg-orange-500 hover:bg-orange-600 text-white py-2.5 font-medium"
          >
            Сбросить фильтры
          </Button>
        </div>
      </div>
    </>
  );
};
