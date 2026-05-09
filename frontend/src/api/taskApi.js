import api from './axiosConfig';
export const fetchTasks = () => api.get(`${import.meta.env.VITE_TASK_SERVICE_URL}/api/tasks`);
export const createHask = (data) => api.post(`${import.meta.env.VITE_TASK_SERVICE_URL}/api/tasks`, data);
