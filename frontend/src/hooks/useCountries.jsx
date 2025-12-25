import { useState } from 'react';
import { getCountries } from '../services/filmService';

/**
 * Хук для управления странами
 */
export const useCountries = () => {
  const [countriesList, setCountriesList] = useState([]);

  const fetchCountries = async () => {
    try {
      const countriesData = await getCountries();
      setCountriesList(countriesData);
      return countriesData;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка получения списка стран';
      throw errMess;
    }
  };

  return {
    fetchCountries, 
    countriesList
  };
};