import api from './axiosConfig';
export const login = (data) => api.post(`${import.meta.env.VITE_AUTH_SERVICE_URL}/auth/login`, data);
export const register = (data) => api.post(`${import.meta.env.VITE_AUTH_SERVICE_URL}/auth/register`, data);
