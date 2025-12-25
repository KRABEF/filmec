import React, { useEffect, useState } from 'react';
import { Button } from '../components/ui/button';
import { useFilms } from '../hooks/useFilms';
import { useAgeRatings } from '../hooks/useAgeRatings';
import { useCountries } from '../hooks/useCountries'; // Добавляем импорт хука стран

export const LeftMenu = ({ onFiltersChange }) => {
  const { allGenres, genres_name } = useFilms();
  const { fetchAgeRatings, ageRatingsList } = useAgeRatings();
  const { fetchCountries, countriesList } = useCountries(); // Используем хук стран

  useEffect(() => {
    allGenres();
    fetchAgeRatings();
    fetchCountries(); // Получаем страны при загрузке
  }, []);

  const currentYear = new Date().getFullYear();

  const [filters, setFilters] = useState({
    genres: [],
    minRating: 7,
    ageRating: [],
    minYear: 2025,
    countryIds: [], // Изменяем название на countryIds для соответствия API
  });

  const [isGenresOpen, setIsGenresOpen] = useState(false);
  const [isRatingOpen, setIsRatingOpen] = useState(false);
  const [isAgeRatingOpen, setIsAgeRatingOpen] = useState(false);
  const [isYearOpen, setIsYearOpen] = useState(false);
  const [isCountriesOpen, setIsCountriesOpen] = useState(false); // Для стран
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  // Вспомогательная функция для обработки стран
  const getCountryInfo = (country) => {
    if (Array.isArray(country) && country.length >= 3) {
      // Формат: [195, 198, 'СССР']
      return {
        id: country[1], // Второй элемент - ID
        name: country[2], // Третий элемент - название
      };
    }

    if (typeof country === 'object') {
      // Если объект, пробуем получить значения
      const values = Object.values(country);
      if (values.length >= 3 && typeof values[2] === 'string') {
        return {
          id: values[1], // Второе значение - ID
          name: values[2], // Третье значение - название
        };
      }

      // Стандартные форматы
      return {
        id: country.id || country.country_id,
        name: country.name || country.country || country.value,
      };
    }

    // Если страна пришла как строка
    return {
      id: country,
      name: country,
    };
  };

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

  const handleCountryToggle = (countryId) => {
    const newCountryIds = filters.countryIds.includes(countryId)
      ? filters.countryIds.filter((c) => c !== countryId)
      : [...filters.countryIds, countryId];

    const newFilters = { ...filters, countryIds: newCountryIds };
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
      countryIds: [], // Сбрасываем страны тоже
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
              {genres_name.map((genre) => (
                <label key={genre} className="flex items-center space-x-3 cursor-pointer py-2">
                  <input
                    type="checkbox"
                    checked={filters.genres.includes(genre)}
                    onChange={() => handleGenreToggle(genre)}
                    className="w-5 h-5 accent-orange-500"
                  />
                  <span className="text-neutral-300 hover:text-white text-base">
                    {typeof genre === 'object' ? genre.genres : genre}
                  </span>
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
              {ageRatingsList.map((rating) => {
                const ratingValue =
                  typeof rating === 'object'
                    ? rating.name || rating.rating || rating.value
                    : rating;

                return (
                  <label
                    key={ratingValue}
                    className="flex items-center space-x-3 cursor-pointer py-2"
                  >
                    <input
                      type="checkbox"
                      checked={filters.ageRating.includes(ratingValue)}
                      onChange={() => handleAgeRatingToggle(ratingValue)}
                      className="w-5 h-5 accent-orange-500"
                    />
                    <span className="text-neutral-300 text-base">{ratingValue}</span>
                  </label>
                );
              })}
            </div>
          )}
        </div>

        {/* Секция страны */}
        <div className="mb-6">
          <button
            onClick={() => setIsCountriesOpen(!isCountriesOpen)}
            className="flex justify-between items-center w-full text-left py-3"
          >
            <h3 className="text-lg font-semibold text-white">Страна</h3>
            <span className="text-neutral-400 text-xl">{isCountriesOpen ? '−' : '+'}</span>
          </button>

          {isCountriesOpen && (
            <div className="mt-2 space-y-3 pl-2">
              {countriesList.map((country) => {
                // Обрабатываем данные стран аналогично возрастным рейтингам
                const countryValue =
                  typeof country === 'object'
                    ? country.name || country.country || country.value
                    : country;
                const countryId =
                  typeof country === 'object' ? country.id || country.country_id : country;

                return (
                  <label
                    key={countryId}
                    className="flex items-center space-x-3 cursor-pointer py-2"
                  >
                    <input
                      type="checkbox"
                      checked={filters.countryIds.includes(countryId)}
                      onChange={() => handleCountryToggle(countryId)}
                      className="w-5 h-5 accent-orange-500"
                    />
                    <span className="text-neutral-300 hover:text-white text-base">
                      {countryValue}
                    </span>
                  </label>
                );
              })}
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

      {/* Обертка для скролла */}
      <div className="hidden shadow-xs lg:flex flex-col w-80 max-h-[calc(100vh-120px)] dark:bg-neutral-900 bg-white rounded-lg p-6">
        {/* Десктопная версия (оригинальная) */}
        <div className="flex-1 min-h-0 overflow-y-auto pr-2 mb-4">
          {/* Секция жанров */}
          <div className="mb-6">
            <button
              onClick={() => setIsGenresOpen(!isGenresOpen)}
              className="flex justify-between items-center w-full text-left hover:bg-transparent focus:outline-none"
            >
              <h2 className="text-xl font-bold dark:text-white text-neutral-900">Жанры</h2>
              <span className="text-neutral-400">{isGenresOpen ? '−' : '+'}</span>
            </button>

            {isGenresOpen && (
              <div className="mt-4 space-y-2">
                {genres_name.map((genre) => (
                  <label
                    key={genre}
                    className="flex items-center space-x-3 cursor-pointer hover:bg-neutral-100 dark:hover:bg-neutral-800 px-2 py-1 rounded transition-colors"
                  >
                    <input
                      type="checkbox"
                      checked={filters.genres.includes(genre)}
                      onChange={() => handleGenreToggle(genre)}
                      className="w-4 h-4 accent-orange-500"
                    />
                    <span className="text-neutral-800 hover:text-black dark:text-neutral-300 dark:hover:text-white">
                      {typeof genre === 'object' ? genre.genres : genre}
                    </span>
                  </label>
                ))}
              </div>
            )}
          </div>

          <div className="border-t dark:border-neutral-800 border-neutral-300 my-4"></div>

          {/* Рейтинг */}
          <div className="mb-6">
            <h3 className="text-lg font-semibold mb-3 dark:text-white text-neutral-900">
              Рейтинг от {filters.minRating}
            </h3>

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
          hover:[&::-webkit-slider-thumb]:scale-110 transition-transform"
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

          {/* Возрастной рейтинг */}
          <div className="mb-6">
            <h3 className="text-lg font-semibold mb-3 dark:text-white text-neutral-900">
              Возрастной рейтинг:
            </h3>

            <div className="grid grid-cols-2 gap-2">
              {ageRatingsList.map((rating) => {
                const ratingValue =
                  typeof rating === 'object'
                    ? rating.name || rating.rating || rating.value
                    : rating;

                return (
                  <label
                    key={ratingValue}
                    className="flex items-center space-x-2 cursor-pointer hover:bg-neutral-100 dark:hover:bg-neutral-800 px-2 py-1 rounded transition-colors"
                  >
                    <input
                      type="checkbox"
                      checked={filters.ageRating.includes(ratingValue)}
                      onChange={() => handleAgeRatingToggle(ratingValue)}
                      className="w-4 h-4 accent-orange-500"
                    />
                    <span className="dark:text-neutral-300 text-neutral-700">{ratingValue}</span>
                  </label>
                );
              })}
            </div>
          </div>

          {/* Страна */}
          <div className="mb-6">
            <button
              onClick={() => setIsCountriesOpen(!isCountriesOpen)}
              className="flex justify-between items-center w-full text-left hover:bg-transparent focus:outline-none mb-3"
            >
              <h3 className="text-lg font-semibold dark:text-white text-neutral-900">Страна</h3>
              <span className="text-neutral-400">{isCountriesOpen ? '−' : '+'}</span>
            </button>

            {isCountriesOpen && (
              <div className="space-y-2">
                {countriesList.map((country) => {
                  // Обрабатываем данные стран аналогично возрастным рейтингам
                  const countryValue =
                    typeof country === 'object'
                      ? country.name || country.country || country.value
                      : country;
                  const countryId =
                    typeof country === 'object' ? country.id || country.country_id : country;

                  return (
                    <label
                      key={countryId}
                      className="flex items-center space-x-2 cursor-pointer hover:bg-neutral-100 dark:hover:bg-neutral-800 px-2 py-1 rounded transition-colors"
                    >
                      <input
                        type="checkbox"
                        checked={filters.countryIds.includes(countryId)}
                        onChange={() => handleCountryToggle(countryId)}
                        className="w-4 h-4 accent-orange-500"
                      />
                      <span className="dark:text-neutral-300 text-neutral-700">{countryValue}</span>
                    </label>
                  );
                })}
              </div>
            )}
          </div>

          {/* Год выпуска */}
          <div>
            <div className="flex items-center justify-between mb-3">
              <h3 className="text-lg font-semibold dark:text-white text-neutral-900">
                Год выпуска от
              </h3>

              <input
                type="number"
                value={filters.minYear}
                onChange={handleYearInputChange}
                min="1900"
                max={currentYear}
                className="w-24 px-2 py-1 bg-white dark:bg-neutral-800 border border-neutral-200/90 dark:border-neutral-900/90 rounded-lg 
          text-neutral-800 dark:text-neutral-100 text-md 
          focus:outline-none focus:ring-2 focus:ring-orange-500 focus:border-transparent shadow-xs
          hover:border-orange-400 transition-colors"
              />
            </div>
          </div>
        </div>

        <div className="pt-4 border-t border-neutral-300 dark:border-neutral-800">
          <Button className="w-full rounded-lg bg-orange-500 hover:bg-orange-600 text-white py-2.5 font-medium transition-all duration-200">
            Найти
          </Button>
        </div>
      </div>
    </>
  );
};
