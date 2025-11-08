import { GET } from './client';

export const usersApi = async () => {
  try {
    const response = await GET(`/api/users/select`);
    return response.data;
  } catch (err) {
    console.error('Error:', err);
    throw err;
  }
};
