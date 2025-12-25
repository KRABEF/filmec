import { GET } from './client';

const endpoint = 'api/films/';

// /:id/full - получение конкретного фильма
export const filmId = async (id) => {
  try {
    const response = await GET(`${endpoint}${id}/full`);
    return response.data;
  } catch (err) {
    console.error('Error in filmId:', err);
    throw err;
  }
};
