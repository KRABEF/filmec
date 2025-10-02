import React, { useState } from 'react';
import {Button} from '../components/ui/button';
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

  const [isGenresOpen, setIsGenresOpen] = useState(true);

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

  return (
    <div className="w-80 bg-neutral-900 rounded-lg p-6 border border-neutral-800">
      {/* Секция жанров */}
      <div className="mb-6">
        <button
          onClick={() => setIsGenresOpen(!isGenresOpen)}
          className="flex justify-between items-center w-full text-left"
        >
          <h2 className="text-xl font-bold text-white">Жанры</h2>
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
                <span className="text-neutral-300 hover:text-white">{genre}</span>
              </label>
            ))}
          </div>
        )}
      </div>

      {/* Разделитель */}
      <div className="border-t border-neutral-800 my-4"></div>

      {/* Секция рейтинга */}
      <div className="mb-6">
        <h3 className="text-lg font-semibold text-white mb-3">Рейтинг от {filters.minRating}</h3>
        <div className="relative">
          <input
            type="range"
            min="0"
            max="9"
            step="1"
            value={filters.minRating}
            onChange={(e) => handleRatingChange(parseInt(e.target.value))}
            className="w-full h-1.5 bg-neutral-700 rounded-full appearance-none cursor-pointer 
                     [&::-webkit-slider-thumb]:appearance-none [&::-webkit-slider-thumb]:h-5 [&::-webkit-slider-thumb]:w-5 
                     [&::-webkit-slider-thumb]:rounded-full [&::-webkit-slider-thumb]:bg-orange-500 
                     [&::-webkit-slider-thumb]:border-2 [&::-webkit-slider-thumb]:border-neutral-900 
                     [&::-moz-range-thumb]:h-5 [&::-moz-range-thumb]:w-5 [&::-moz-range-thumb]:rounded-full 
                     [&::-moz-range-thumb]:bg-orange-500 [&::-moz-range-thumb]:border-2 [&::-moz-range-thumb]:border-neutral-900"
          />
          {/* Деления */}
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

      {/* Секция возрастного рейтинга */}
      <div className="mb-6">
        <h3 className="text-lg font-semibold text-white mb-3">Возрастной рейтинг:</h3>
        <div className="grid grid-cols-2 gap-2">
          {ageRatings.map((rating) => (
            <label key={rating} className="flex items-center space-x-2 cursor-pointer">
              <input
                type="checkbox"
                checked={filters.ageRating.includes(rating)}
                onChange={() => handleAgeRatingToggle(rating)}
                className="w-4 h-4 accent-orange-500"
              />
              <span className="text-neutral-300">{rating}</span>
            </label>
          ))}
        </div>
      </div>

      {/* Секция года выпуска */}
      <div>
        <div className="flex items-center justify-between mb-3">
          <h3 className="text-lg font-semibold text-white">Год выпуска от</h3>
          <div className="flex items-center space-x-2">
            <input
              type="number"
              value={filters.minYear}
              onChange={handleYearInputChange}
              min="1900"
              max={currentYear}
              className="w-30 px-2 py-1 bg-neutral-800 border border-neutral-600 rounded text-white text-md 
                       focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent"
            />
          </div>
        </div>
        <Button>
        Найти
      </Button>
    </div>
    </div>
  );
};
