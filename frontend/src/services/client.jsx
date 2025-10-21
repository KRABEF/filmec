import axios from 'axios';

const baseClient = axios.create({
  baseURL: 'http://localhost:3001/',
  timeout: 1000,
});

export const GET = baseClient.get.bind(baseClient);
export const POST = baseClient.post.bind(baseClient);
export const PUT = baseClient.put.bind(baseClient);
export const DELETE = baseClient.delete.bind(baseClient);
