import { GET } from './client';

export const getMovies = async () => {
  try {
    const response = await GET(`/movies`);
    return response.data;
  } catch (err) {
    console.error('Error:', err);
    throw err;
  }
};
