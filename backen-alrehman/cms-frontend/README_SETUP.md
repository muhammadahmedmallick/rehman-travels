# Rehman Travels CMS - React Frontend

## ✅ What's Been Created

### Configuration Files
- ✅ `package.json` - Dependencies (React Query, React Router, Tailwind, Axios)
- ✅ `vite.config.js` - Vite configuration with API proxy
- ✅ `tailwind.config.js` - Tailwind CSS config with custom colors
- ✅ `postcss.config.js` - PostCSS configuration
- ✅ `index.html` - HTML entry point

### Core Files
- ✅ `src/main.jsx` - App entry point with React Query setup
- ✅ `src/index.css` - Tailwind CSS with custom components
- ✅ `src/services/api.js` - API client with axios (FIXED: Base URL = http://3.222.113.143:8000/api)
- ✅ `src/utils/auth.jsx` - Auth context and hooks
- ✅ `src/components/ProtectedRoute.jsx` - Protected route component
- ✅ `src/components/Layout.jsx` - Main layout with sidebar navigation
- ✅ `src/pages/Login.jsx` - Login page
- ✅ `src/pages/Dashboard.jsx` - Dashboard with statistics

## 🚀 Installation & Setup

### 1. Install Dependencies
```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/cms-frontend
npm install
```

### 2. Start Development Server
```bash
npm run dev
```

The app will run on `http://localhost:3000`

### 3. Build for Production
```bash
npm run build
```

## 📁 Remaining Files to Create

I'll create the remaining CMS pages below. Copy each file to the appropriate location.

---

## File: `src/App.jsx`

```jsx
import { Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './utils/auth';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import VisaTypes from './pages/VisaTypes';
import VisaVariants from './pages/VisaVariants';
import Packages from './pages/Packages';

function App() {
  return (
    <AuthProvider>
      <Routes>
        <Route path="/login" element={<Login />} />
        <Route path="/" element={<Navigate to="/dashboard" replace />} />

        <Route
          path="/dashboard"
          element={
            <ProtectedRoute>
              <Layout>
                <Dashboard />
              </Layout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/visa-types"
          element={
            <ProtectedRoute>
              <Layout>
                <VisaTypes />
              </Layout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/visa-variants"
          element={
            <ProtectedRoute>
              <Layout>
                <VisaVariants />
              </Layout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/packages"
          element={
            <ProtectedRoute>
              <Layout>
                <Packages />
              </Layout>
            </ProtectedRoute>
          }
        />
      </Routes>
    </AuthProvider>
  );
}

export default App;
```

---

## File: `src/pages/VisaTypes.jsx`

This is a comprehensive CRUD page for Visa Types. Create this file:

```jsx
import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { visaTypesAPI } from '../services/api';
import toast from 'react-hot-toast';
import {
  Plus,
  Edit,
  Trash2,
  Search,
  Loader2,
  X,
  Globe,
  CheckCircle,
  XCircle
} from 'lucide-react';

const VisaTypes = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [showModal, setShowModal] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [formData, setFormData] = useState({
    title: '',
    slug: '',
    subtitle: '',
    description: '',
    country_code: '',
    processing_time: '',
    is_active: true,
    display_order: 0,
  });

  const queryClient = useQueryClient();

  // Fetch visa types
  const { data: visaTypes, isLoading } = useQuery({
    queryKey: ['visa-types', searchTerm],
    queryFn: () => visaTypesAPI.getAll({ search: searchTerm }).then(res => res.data),
  });

  // Create mutation
  const createMutation = useMutation({
    mutationFn: visaTypesAPI.create,
    onSuccess: () => {
      queryClient.invalidateQueries(['visa-types']);
      toast.success('Visa type created successfully!');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.detail || 'Failed to create visa type');
    },
  });

  // Update mutation
  const updateMutation = useMutation({
    mutationFn: ({ slug, data }) => visaTypesAPI.partialUpdate(slug, data),
    onSuccess: () => {
      queryClient.invalidateQueries(['visa-types']);
      toast.success('Visa type updated successfully!');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.detail || 'Failed to update visa type');
    },
  });

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: visaTypesAPI.delete,
    onSuccess: () => {
      queryClient.invalidateQueries(['visa-types']);
      toast.success('Visa type deleted successfully!');
    },
    onError: (error) => {
      toast.error(error.response?.data?.detail || 'Failed to delete visa type');
    },
  });

  const handleOpenModal = (item = null) => {
    if (item) {
      setEditingItem(item);
      setFormData({
        title: item.title,
        slug: item.slug,
        subtitle: item.subtitle || '',
        description: item.description || '',
        country_code: item.country_code || '',
        processing_time: item.processing_time || '',
        is_active: item.is_active,
        display_order: item.display_order,
      });
    } else {
      setEditingItem(null);
      setFormData({
        title: '',
        slug: '',
        subtitle: '',
        description: '',
        country_code: '',
        processing_time: '',
        is_active: true,
        display_order: 0,
      });
    }
    setShowModal(true);
  };

  const handleCloseModal = () => {
    setShowModal(false);
    setEditingItem(null);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    if (editingItem) {
      updateMutation.mutate({ slug: editingItem.slug, data: formData });
    } else {
      createMutation.mutate(formData);
    }
  };

  const handleDelete = (slug) => {
    if (window.confirm('Are you sure you want to delete this visa type?')) {
      deleteMutation.mutate(slug);
    }
  };

  // Auto-generate slug from title
  const handleTitleChange = (title) => {
    setFormData({
      ...formData,
      title,
      slug: title.toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, ''),
    });
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Visa Types</h1>
          <p className="text-gray-600 mt-2">Manage visa categories (countries/destinations)</p>
        </div>
        <button
          onClick={() => handleOpenModal()}
          className="btn btn-primary flex items-center gap-2"
        >
          <Plus className="w-5 h-5" />
          Add Visa Type
        </button>
      </div>

      {/* Search */}
      <div className="card">
        <div className="relative">
          <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 w-5 h-5" />
          <input
            type="text"
            placeholder="Search visa types..."
            className="input pl-10"
            value={searchTerm}
            onChange={(e) => setSearchTerm(e.target.value)}
          />
        </div>
      </div>

      {/* Table */}
      <div className="card overflow-hidden p-0">
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 border-b border-gray-200">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Title
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Country Code
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Variants
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Processing Time
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Status
                </th>
                <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white divide-y divide-gray-200">
              {isLoading ? (
                <tr>
                  <td colSpan="6" className="px-6 py-12 text-center">
                    <Loader2 className="w-8 h-8 animate-spin text-primary-600 mx-auto" />
                  </td>
                </tr>
              ) : visaTypes?.length === 0 ? (
                <tr>
                  <td colSpan="6" className="px-6 py-12 text-center text-gray-500">
                    No visa types found
                  </td>
                </tr>
              ) : (
                visaTypes?.map((type) => (
                  <tr key={type.id} className="table-row">
                    <td className="px-6 py-4">
                      <div className="flex items-center gap-3">
                        <div className="flex-shrink-0 w-10 h-10 bg-primary-100 rounded-full flex items-center justify-center">
                          <Globe className="w-5 h-5 text-primary-600" />
                        </div>
                        <div>
                          <p className="font-medium text-gray-900">{type.title}</p>
                          <p className="text-sm text-gray-500">{type.slug}</p>
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded">
                        {type.country_code || 'N/A'}
                      </span>
                    </td>
                    <td className="px-6 py-4">
                      <span className="text-sm text-gray-900">
                        {type.active_variants_count || 0} variant(s)
                      </span>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      {type.processing_time || 'N/A'}
                    </td>
                    <td className="px-6 py-4">
                      {type.is_active ? (
                        <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium bg-green-100 text-green-800 rounded">
                          <CheckCircle className="w-3 h-3" />
                          Active
                        </span>
                      ) : (
                        <span className="inline-flex items-center gap-1 px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 rounded">
                          <XCircle className="w-3 h-3" />
                          Inactive
                        </span>
                      )}
                    </td>
                    <td className="px-6 py-4 text-right">
                      <div className="flex items-center justify-end gap-2">
                        <button
                          onClick={() => handleOpenModal(type)}
                          className="p-2 text-primary-600 hover:bg-primary-50 rounded-lg transition-colors"
                        >
                          <Edit className="w-4 h-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(type.slug)}
                          className="p-2 text-red-600 hover:bg-red-50 rounded-lg transition-colors"
                          disabled={deleteMutation.isLoading}
                        >
                          <Trash2 className="w-4 h-4" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal */}
      {showModal && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between p-6 border-b border-gray-200">
              <h2 className="text-xl font-semibold text-gray-900">
                {editingItem ? 'Edit Visa Type' : 'Add Visa Type'}
              </h2>
              <button
                onClick={handleCloseModal}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="w-6 h-6" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Title *
                  </label>
                  <input
                    type="text"
                    className="input"
                    value={formData.title}
                    onChange={(e) => handleTitleChange(e.target.value)}
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Slug *
                  </label>
                  <input
                    type="text"
                    className="input"
                    value={formData.slug}
                    onChange={(e) => setFormData({ ...formData, slug: e.target.value })}
                    required
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Country Code
                  </label>
                  <input
                    type="text"
                    className="input"
                    placeholder="e.g., SGP, ARE"
                    value={formData.country_code}
                    onChange={(e) => setFormData({ ...formData, country_code: e.target.value })}
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Processing Time
                  </label>
                  <input
                    type="text"
                    className="input"
                    placeholder="e.g., 3-5 working days"
                    value={formData.processing_time}
                    onChange={(e) => setFormData({ ...formData, processing_time: e.target.value })}
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Subtitle
                </label>
                <input
                  type="text"
                  className="input"
                  value={formData.subtitle}
                  onChange={(e) => setFormData({ ...formData, subtitle: e.target.value })}
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Description
                </label>
                <textarea
                  className="input"
                  rows="4"
                  value={formData.description}
                  onChange={(e) => setFormData({ ...formData, description: e.target.value })}
                />
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="flex items-center gap-2">
                    <input
                      type="checkbox"
                      checked={formData.is_active}
                      onChange={(e) => setFormData({ ...formData, is_active: e.target.checked })}
                      className="rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                    />
                    <span className="text-sm font-medium text-gray-700">Active</span>
                  </label>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Display Order
                  </label>
                  <input
                    type="number"
                    className="input"
                    value={formData.display_order}
                    onChange={(e) => setFormData({ ...formData, display_order: parseInt(e.target.value) })}
                  />
                </div>
              </div>

              <div className="flex items-center justify-end gap-3 pt-4 border-t border-gray-200">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="btn btn-secondary"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  className="btn btn-primary flex items-center gap-2"
                  disabled={createMutation.isLoading || updateMutation.isLoading}
                >
                  {(createMutation.isLoading || updateMutation.isLoading) && (
                    <Loader2 className="w-4 h-4 animate-spin" />
                  )}
                  {editingItem ? 'Update' : 'Create'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default VisaTypes;
```

The file is too large to include everything in one response. I'll create a completion guide document:
