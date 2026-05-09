import axios from 'axios';

// Use environment variable or fallback to EC2 server
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://3.222.113.143:8000/api';

const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Content-Type': 'application/json',
  },
  withCredentials: false, // Set to true if using cookies for auth
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

// Auth API (using axios directly to avoid interceptors on login)
export const authAPI = {
  login: (credentials) => axios.post(`${API_BASE_URL}/mobile/auth/login/`, credentials, {
    headers: { 'Content-Type': 'application/json' }
  }),
  register: (userData) => axios.post(`${API_BASE_URL}/mobile/auth/register/`, userData, {
    headers: { 'Content-Type': 'application/json' }
  }),
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

// Validation API
export const validationSchemasAPI = {
  getAll: (params) => api.get('/validation/schemas/', { params }),
  getById: (id) => api.get(`/validation/schemas/${id}/`),
  create: (data) => api.post('/validation/schemas/', data),
  update: (id, data) => api.put(`/validation/schemas/${id}/`, data),
  partialUpdate: (id, data) => api.patch(`/validation/schemas/${id}/`, data),
  delete: (id) => api.delete(`/validation/schemas/${id}/`),
};

export const fieldRulesAPI = {
  getAll: (params) => api.get('/validation/field-rules/', { params }),
  getById: (id) => api.get(`/validation/field-rules/${id}/`),
  create: (data) => api.post('/validation/field-rules/', data),
  update: (id, data) => api.put(`/validation/field-rules/${id}/`, data),
  partialUpdate: (id, data) => api.patch(`/validation/field-rules/${id}/`, data),
  delete: (id) => api.delete(`/validation/field-rules/${id}/`),
};

// Payment API
export const apgTransactionsAPI = {
  getAll: (params) => api.get('/payments/apg-transactions/', { params }),
  getById: (id) => api.get(`/payments/apg-transactions/${id}/`),
  create: (data) => api.post('/payments/apg-transactions/', data),
  update: (id, data) => api.put(`/payments/apg-transactions/${id}/`, data),
  partialUpdate: (id, data) => api.patch(`/payments/apg-transactions/${id}/`, data),
  delete: (id) => api.delete(`/payments/apg-transactions/${id}/`),
};

// Filter Sort Config API
export const filterSortConfigAPI = {
  getAll: (params) => api.get('/core/filter-sort-configs/', { params }),
  getById: (id) => api.get(`/core/filter-sort-configs/${id}/`),
  getByListingName: (listingName) => api.get(`/core/filter-config/${listingName}/`),
  create: (data) => api.post('/core/filter-sort-configs/', data),
  update: (id, data) => api.put(`/core/filter-sort-configs/${id}/`, data),
  partialUpdate: (id, data) => api.patch(`/core/filter-sort-configs/${id}/`, data),
  delete: (id) => api.delete(`/core/filter-sort-configs/${id}/`),
};

export default api;
