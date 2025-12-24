import { useState } from 'react';
import { getAgeRatings } from '../services/filmService';

/**
 * Хук для управления возрастными рейтингами
 */
export const useAgeRatings = () => {
  const [ageRatingsList, setAgeRatingsList] = useState([]);

  const fetchAgeRatings = async () => {
    try {
      const ratingsData = await getAgeRatings();
      setAgeRatingsList(ratingsData);
      return ratingsData;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка получения возрастных рейтингов';
      throw errMess;
    }
  };

  return {
    fetchAgeRatings, 
    ageRatingsList
  };
};