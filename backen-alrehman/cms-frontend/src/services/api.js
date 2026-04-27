import axios from 'axios';

const API_BASE_URL = 'http://3.222.113.143:8000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor to add auth token
api.interceptors.request.use(
  (config) => {
    const token = localStorage.getItem('token');
    if (token) {
      config.headers.Authorization = `Bearer ${token}`;
    }
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor for error handling
api.interceptors.response.use(
  (response) => response,
  (error) => {
    if (error.response?.status === 401) {
      localStorage.removeItem('token');
      localStorage.removeItem('user');
      window.location.href = '/login';
    }
    return Promise.reject(error);
  }
);

// Auth API
export const authAPI = {
  login: (credentials) => axios.post(`${API_BASE_URL}/mobile/auth/login/`, credentials),
  register: (userData) => axios.post(`${API_BASE_URL}/mobile/auth/register/`, userData),
  getProfile: () => api.get('/mobile/auth/profile/'),
};

// Visa Types API
export const visaTypesAPI = {
  getAll: (params) => api.get('/mobile/visas/types/', { params }),
  getBySlug: (slug) => api.get(`/mobile/visas/types/${slug}/`),
  create: (data) => api.post('/mobile/visas/types/', data),
  update: (slug, data) => api.put(`/mobile/visas/types/${slug}/`, data),
  partialUpdate: (slug, data) => api.patch(`/mobile/visas/types/${slug}/`, data),
  delete: (slug) => api.delete(`/mobile/visas/types/${slug}/`),
  getFeatured: () => api.get('/mobile/visas/types/featured/'),
};

// Visa Variants API
export const visaVariantsAPI = {
  getAll: (params) => api.get('/mobile/visas/variants/', { params }),
  getBySlug: (slug) => api.get(`/mobile/visas/variants/${slug}/`),
  create: (data) => api.post('/mobile/visas/variants/', data),
  update: (slug, data) => api.put(`/mobile/visas/variants/${slug}/`, data),
  partialUpdate: (slug, data) => api.patch(`/mobile/visas/variants/${slug}/`, data),
  delete: (slug) => api.delete(`/mobile/visas/variants/${slug}/`),
  getFeatured: () => api.get('/mobile/visas/variants/featured/'),
};

// Visa Rules API
export const visaRulesAPI = {
  getAll: (params) => api.get('/mobile/visas/rules/', { params }),
  getById: (id) => api.get(`/mobile/visas/rules/${id}/`),
  create: (data) => api.post('/mobile/visas/rules/', data),
  update: (id, data) => api.put(`/mobile/visas/rules/${id}/`, data),
  partialUpdate: (id, data) => api.patch(`/mobile/visas/rules/${id}/`, data),
  delete: (id) => api.delete(`/mobile/visas/rules/${id}/`),
};

// Packages API
export const packagesAPI = {
  getAll: (params) => api.get('/mobile/packages/', { params }),
  getBySlug: (slug) => api.get(`/mobile/packages/${slug}/`),
  create: (data) => api.post('/mobile/packages/', data),
  update: (slug, data) => api.put(`/mobile/packages/${slug}/`, data),
  partialUpdate: (slug, data) => api.patch(`/mobile/packages/${slug}/`, data),
  delete: (slug) => api.delete(`/mobile/packages/${slug}/`),
  getFeatured: () => api.get('/mobile/packages/featured/'),
};

export default api;
