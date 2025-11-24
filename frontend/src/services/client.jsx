import axios from 'axios';

const baseClient = axios.create({
  baseURL: 'http://localhost:5075/',
  timeout: 10000,
});

baseClient.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) config.headers.Authorization = `Bearer ${token}`;
    return config;
  },
  (error) => {
    return Promise.reject(error);
  },
);

export const GET = baseClient.get.bind(baseClient);
export const POST = baseClient.post.bind(baseClient);
export const PUT = baseClient.put.bind(baseClient);
export const DELETE = baseClient.delete.bind(baseClient);
