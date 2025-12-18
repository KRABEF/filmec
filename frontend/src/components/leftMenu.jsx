import React, { useState } from 'react';
import { Button } from '../components/ui/button';

export const LeftMenu = ({ onFiltersChange }) => {
  const genres = [
    'Биография',
    'Боевик',
    'Вестерн',
    'Детектив',
    'Для всей семьи',
    'Для детей',
    'Документальные',
  ];

  const ageRatings = ['0+', '6+', '12+', '18+'];
  const currentYear = new Date().getFullYear();

  const [filters, setFilters] = useState({
    genres: [],
    minRating: 7,
    ageRating: [],
    minYear: 2025,
  });

  const [isGenresOpen, setIsGenresOpen] = useState(false);
  const [isRatingOpen, setIsRatingOpen] = useState(false);
  const [isAgeRatingOpen, setIsAgeRatingOpen] = useState(false);
  const [isYearOpen, setIsYearOpen] = useState(false);
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const handleGenreToggle = (genre) => {
    const newGenres = filters.genres.includes(genre)
      ? filters.genres.filter((g) => g !== genre)
      : [...filters.genres, genre];

    const newFilters = { ...filters, genres: newGenres };
    setFilters(newFilters);
    onFiltersChange?.(newFilters);
  };

  const handleRatingChange = (rating) => {
    const newFilters = { ...filters, minRating: rating };
    setFilters(newFilters);
    onFiltersChange?.(newFilters);
  };

  const handleAgeRatingToggle = (rating) => {
    const newAgeRatings = filters.ageRating.includes(rating)
      ? filters.ageRating.filter((r) => r !== rating)
      : [...filters.ageRating, rating];

    const newFilters = { ...filters, ageRating: newAgeRatings };
    setFilters(newFilters);
    onFiltersChange?.(newFilters);
  };

  const handleYearChange = (year) => {
    const validatedYear = Math.max(1900, Math.min(year, currentYear));
    const newFilters = { ...filters, minYear: validatedYear };
    setFilters(newFilters);
    onFiltersChange?.(newFilters);
  };

  const handleYearInputChange = (e) => {
    const value = e.target.value;
    if (value === '') {
      handleYearChange(1900);
      return;
    }

    const year = parseInt(value);
    if (!isNaN(year)) {
      handleYearChange(year);
    }
  };

  const resetFilters = () => {
    const newFilters = {
      genres: [],
      minRating: 7,
      ageRating: [],
      minYear: 2025,
    };
    setFilters(newFilters);
    onFiltersChange?.(newFilters);
  };

  // Мобильная версия
  return (
    <>
      {/* Кнопка открытия меню на мобильных */}
      <div className="lg:hidden fixed top-26 left-2 z-50">
        <Button
          onClick={() => setIsMenuOpen(!isMenuOpen)}
          className="bg-orange-500 hover:bg-orange-600 text-white px-4 py-2 rounded-lg shadow-lg"
        >
          {'☰ Фильтры'}
        </Button>
      </div>

      {/* Оверлей */}
      {isMenuOpen && (
        <div
          className="lg:hidden fixed inset-0 bg-black/70 z-40"
          onClick={() => setIsMenuOpen(false)}
        />
      )}

      {/* Мобильное меню */}
      <div
        className={`
        lg:hidden fixed left-0 top-0 h-full w-80 bg-neutral-900 rounded-r-lg p-6 border-r border-neutral-800 
        transform z-1000 overflow-y-auto
        ${isMenuOpen ? 'translate-x-0' : '-translate-x-full'}
      `}
      >
        {/* Заголовок и кнопка закрытия */}
        <div className="flex justify-between items-center mb-6">
          <h1 className="text-xl font-bold text-white">Фильтры</h1>
          <button
            onClick={() => setIsMenuOpen(false)}
            className="text-neutral-400 hover:text-white text-2xl"
          >
            ✕
          </button>
        </div>

        {/* Секция жанров */}
        <div className="mb-6">
          <button
            onClick={() => setIsGenresOpen(!isGenresOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h2 className="text-lg font-semibold text-white">Жанры</h2>
            <span className="text-neutral-400 text-xl">{isGenresOpen ? '−' : '+'}</span>
          </button>

          {isGenresOpen && (
            <div className="mt-2 space-y-3 pl-2">
              {genres.map((genre) => (
                <label key={genre} className="flex items-center space-x-3 cursor-pointer py-2">
                  <input
                    type="checkbox"
                    checked={filters.genres.includes(genre)}
                    onChange={() => handleGenreToggle(genre)}
                    className="w-5 h-5 accent-orange-500"
                  />
                  <span className="text-neutral-300 hover:text-white text-base">{genre}</span>
                </label>
              ))}
            </div>
          )}
        </div>

        {/* Разделитель */}
        <div className="border-t border-neutral-800 my-4"></div>

        {/* Секция рейтинга */}
        <div className="mb-6">
          <button
            onClick={() => setIsRatingOpen(!isRatingOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h3 className="text-lg font-semibold text-white">Рейтинг от {filters.minRating}</h3>
            <span className="text-neutral-400 text-xl">{isRatingOpen ? '−' : '+'}</span>
          </button>

          {isRatingOpen && (
            <div className="mt-4 pl-2">
              <div className="relative">
                <input
                  type="range"
                  min="0"
                  max="9"
                  step="1"
                  value={filters.minRating}
                  onChange={(e) => handleRatingChange(parseInt(e.target.value))}
                  className="w-full h-2 bg-neutral-700 rounded-full appearance-none cursor-pointer 
                           [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:h-6 [&::-webkit-slider-thumb]:w-6 
                           [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-orange-500 
                           [&::-webkit-slider-thumb]:border-2 [&::-webkit-slider-thumb]:border-neutral-900 
                           [&::-moz-range-thumb]:h-6 [&::-moz-range-thumb]:w-6 [&::-moz-range-thumb]:rounded-full 
                           [&::-moz-range-thumb]:border-2 [&::-moz-range-thumb]:border-neutral-900"
                />
                {/* Деления */}
                <div className="flex justify-between px-1 mt-4">
                  {[0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((num) => (
                    <span
                      key={num}
                      className={`text-sm ${
                        num === filters.minRating ? 'text-orange-500 font-bold' : 'text-neutral-400'
                      }`}
                    >
                      {num}
                    </span>
                  ))}
                </div>
              </div>
            </div>
          )}
        </div>

        {/* Секция возрастного рейтинга */}
        <div className="mb-6">
          <button
            onClick={() => setIsAgeRatingOpen(!isAgeRatingOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h3 className="text-lg font-semibold text-white">Возрастной рейтинг</h3>
            <span className="text-neutral-400 text-xl">{isAgeRatingOpen ? '−' : '+'}</span>
          </button>

          {isAgeRatingOpen && (
            <div className="grid grid-cols-2 gap-3 mt-2 pl-2">
              {ageRatings.map((rating) => (
                <label key={rating} className="flex items-center space-x-3 cursor-pointer py-2">
                  <input
                    type="checkbox"
                    checked={filters.ageRating.includes(rating)}
                    onChange={() => handleAgeRatingToggle(rating)}
                    className="w-5 h-5 accent-orange-500"
                  />
                  <span className="text-neutral-300 text-base">{rating}</span>
                </label>
              ))}
            </div>
          )}
        </div>

        {/* Секция года выпуска */}
        <div className="mb-6">
          <button
            onClick={() => setIsYearOpen(!isYearOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h3 className="text-lg font-semibold text-white">Год выпуска</h3>
            <span className="text-neutral-400 text-xl">{isYearOpen ? '−' : '+'}</span>
          </button>

          {isYearOpen && (
            <div className="mt-2 pl-2">
              <div className="flex items-center space-x-3">
                <span className="text-neutral-300 text-base">От:</span>
                <input
                  type="number"
                  value={filters.minYear}
                  onChange={handleYearInputChange}
                  min="1900"
                  max={currentYear}
                  className="w-24 px-3 py-2 bg-neutral-800 border border-neutral-600 rounded text-white text-base 
                           focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
                />
              </div>
            </div>
          )}
        </div>

        {/* Кнопки действий */}
        <div className="flex flex-col space-y-3 mt-8">
          <Button
            onClick={() => setIsMenuOpen(false)}
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

      {/* Десктопная версия (оригинальная) */}
      <div className="hidden  shadow-xs lg:block w-80 dark:bg-neutral-900 bg-white rounded-lg p-6">
        {/* Оригинальный код десктопной версии */}
        <div className="mb-6">
          <button
            onClick={() => setIsGenresOpen(!isGenresOpen)}
            className="flex justify-between items-center w-full text-left"
          >
            <h2 className="text-xl font-bold">Жанры</h2>
            <span className="text-neutral-400">{isGenresOpen ? '−' : '+'}</span>
          </button>

          {isGenresOpen && (
            <div className="mt-4 space-y-2">
              {genres.map((genre) => (
                <label key={genre} className="flex items-center space-x-3 cursor-pointer">
                  <input
                    type="checkbox"
                    checked={filters.genres.includes(genre)}
                    onChange={() => handleGenreToggle(genre)}
                    className="w-4 h-4 accent-orange-500"
                  />
                  <span className="text-neutral-800 hover:text-black dark:text-neutral-300 dark:hover:text-white">
                    {genre}
                  </span>
                </label>
              ))}
            </div>
          )}
        </div>

        <div className="border-t dark:border-neutral-800 border-neutral-300 my-4"></div>

        <div className="mb-6">
          <h3 className="text-lg font-semibold mb-3">Рейтинг от {filters.minRating}</h3>

          <div className="relative">
            <input
              type="range"
              min="0"
              max="9"
              step="1"
              value={filters.minRating}
              onChange={(e) => handleRatingChange(parseInt(e.target.value))}
              className="w-full h-1.5 bg-gradient-to-r from-orange-400/40 to-orange-600/40 rounded-full appearance-none cursor-pointer 
                 [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:w-5 
                 [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-orange-500 
                 [&::-webkit-slider-thumb]:shadow-[0_0_8px_rgba(255,140,0,0.5)]
                 "
            />
            <div className="flex justify-between px-1 mt-3">
              {[0, 1, 2, 3, 4, 5, 6, 7, 8, 9].map((num) => (
                <span
                  key={num}
                  className={`text-xs ${
                    num === filters.minRating ? 'text-orange-500 font-bold' : 'text-neutral-400'
                  }`}
                >
                  {num}
                </span>
              ))}
            </div>
          </div>
        </div>

        <div className="mb-6">
          <h3 className="text-lg font-semibold mb-3">Возрастной рейтинг:</h3>
          <div className="grid grid-cols-2 gap-2">
            {ageRatings.map((rating) => (
              <label key={rating} className="flex items-center space-x-2 cursor-pointer">
                <input
                  type="checkbox"
                  checked={filters.ageRating.includes(rating)}
                  onChange={() => handleAgeRatingToggle(rating)}
                  className="w-4 h-4 accent-orange-500"
                />
                <span className="dark:text-neutral-300 text-neutral-700">{rating}</span>
              </label>
            ))}
          </div>
        </div>

        <div>
          <div className="flex items-center justify-between mb-3">
            <h3 className="text-lg font-semibold">Год выпуска от</h3>
            <div className="flex items-center space-x-2">
              <input
                type="number"
                value={filters.minYear}
                onChange={handleYearInputChange}
                min="1900"
                max={currentYear}
                className="w-24 px-2 py-1 bg-white dark:bg-neutral-800 border border-neutral-200/90 dark:border-neutral-900/90 rounded-lg text-neutral-800 dark:text-neutral-100 text-md 
                   focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent shadow-xs"
              />
            </div>
          </div>
          <Button>Найти</Button>
        </div>
      </div>
    </>
  );
};
