import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { packagesAPI } from '../services/api';
import toast from 'react-hot-toast';
import { Plus, Edit2, Trash2, Search, X } from 'lucide-react';

const Packages = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const queryClient = useQueryClient();

  const [formData, setFormData] = useState({
    title: '',
    slug: '',
    subtitle: '',
    description: '',
    package_type: 'umrah',
    price: '',
    currency: 'PKR',
    video_url: '',
    is_active: true,
    is_featured: false,
  });

  // Fetch packages
  const { data: packages, isLoading } = useQuery({
    queryKey: ['packages', searchTerm],
    queryFn: () => packagesAPI.getAll({ search: searchTerm }).then(res => {
      const data = res.data;
      return Array.isArray(data) ? data : (data?.results || []);
    }),
  });

  // Create mutation
  const createMutation = useMutation({
    mutationFn: packagesAPI.create,
    onSuccess: () => {
      queryClient.invalidateQueries(['packages']);
      toast.success('Package created successfully');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to create package');
    },
  });

  // Update mutation
  const updateMutation = useMutation({
    mutationFn: ({ slug, data }) => packagesAPI.update(slug, data),
    onSuccess: () => {
      queryClient.invalidateQueries(['packages']);
      toast.success('Package updated successfully');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to update package');
    },
  });

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: packagesAPI.delete,
    onSuccess: () => {
      queryClient.invalidateQueries(['packages']);
      toast.success('Package deleted successfully');
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to delete package');
    },
  });

  const handleOpenModal = (item = null) => {
    if (item) {
      setEditingItem(item);
      setFormData({
        title: item.title || '',
        slug: item.slug || '',
        subtitle: item.subtitle || '',
        description: item.description || '',
        package_type: item.package_type || 'umrah',
        price: item.price || '',
        currency: item.currency || 'PKR',
        video_url: item.video_url || '',
        is_active: item.is_active ?? true,
        is_featured: item.is_featured ?? false,
      });
    } else {
      setEditingItem(null);
      setFormData({
        title: '',
        slug: '',
        subtitle: '',
        description: '',
        package_type: 'umrah',
        price: '',
        currency: 'PKR',
        video_url: '',
        is_active: true,
        is_featured: false,
      });
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
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
    if (window.confirm('Are you sure you want to delete this package?')) {
      deleteMutation.mutate(slug);
    }
  };

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: type === 'checkbox' ? checked : value
    }));
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Packages</h1>
          <p className="text-gray-600 mt-1">Manage Umrah and travel packages</p>
        </div>
        <button
          onClick={() => handleOpenModal()}
          className="btn-primary"
        >
          <Plus className="h-5 w-5" />
          Add Package
        </button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
        <input
          type="text"
          placeholder="Search packages..."
          value={searchTerm}
          onChange={(e) => setSearchTerm(e.target.value)}
          className="input pl-10"
        />
      </div>

      {/* Table */}
      <div className="card overflow-hidden">
        {isLoading ? (
          <div className="p-8 text-center">
            <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary-600 mx-auto"></div>
            <p className="mt-4 text-gray-600">Loading...</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Title
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Type
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Price
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
                {packages?.length === 0 ? (
                  <tr>
                    <td colSpan="5" className="px-6 py-12 text-center text-gray-500">
                      No packages found
                    </td>
                  </tr>
                ) : (
                  packages?.map((item) => (
                    <tr key={item.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div className="flex items-center">
                          {(item.banner_url || item.thumbnail_url) && (
                            <img
                              src={item.banner_url || item.thumbnail_url}
                              alt={item.title}
                              className="h-10 w-10 rounded-lg object-cover mr-3"
                            />
                          )}
                          <div>
                            <div className="text-sm font-medium text-gray-900">
                              {item.title}
                            </div>
                            {item.subtitle && (
                              <div className="text-sm text-gray-500">
                                {item.subtitle}
                              </div>
                            )}
                          </div>
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="px-2 py-1 text-xs font-semibold rounded-full bg-purple-100 text-purple-800">
                          {item.package_type}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900">
                        {item.currency} {item.price}
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center space-x-2">
                          <span className={`px-2 py-1 text-xs font-semibold rounded-full ${
                            item.is_active
                              ? 'bg-green-100 text-green-800'
                              : 'bg-red-100 text-red-800'
                          }`}>
                            {item.is_active ? 'Active' : 'Inactive'}
                          </span>
                          {item.is_featured && (
                            <span className="px-2 py-1 text-xs font-semibold rounded-full bg-yellow-100 text-yellow-800">
                              Featured
                            </span>
                          )}
                        </div>
                      </td>
                      <td className="px-6 py-4 text-right text-sm font-medium">
                        <button
                          onClick={() => handleOpenModal(item)}
                          className="text-primary-600 hover:text-primary-900 mr-4"
                        >
                          <Edit2 className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(item.slug)}
                          className="text-red-600 hover:text-red-900"
                        >
                          <Trash2 className="h-4 w-4" />
                        </button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg max-w-2xl w-full max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between p-6 border-b">
              <h2 className="text-xl font-semibold">
                {editingItem ? 'Edit Package' : 'Add Package'}
              </h2>
              <button
                onClick={handleCloseModal}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="h-6 w-6" />
              </button>
            </div>

            <form onSubmit={handleSubmit} className="p-6 space-y-4">
              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Package Type *
                </label>
                <select
                  name="package_type"
                  value={formData.package_type}
                  onChange={handleInputChange}
                  required
                  className="input"
                >
                  <option value="umrah">Umrah</option>
                  <option value="hajj">Hajj</option>
                  <option value="tour">Tour</option>
                  <option value="flight">Flight</option>
                  <option value="hotel">Hotel</option>
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Title *
                </label>
                <input
                  type="text"
                  name="title"
                  value={formData.title}
                  onChange={handleInputChange}
                  required
                  className="input"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Slug *
                </label>
                <input
                  type="text"
                  name="slug"
                  value={formData.slug}
                  onChange={handleInputChange}
                  required
                  placeholder="e.g., umrah-package-15-days"
                  className="input"
                />
                <p className="text-xs text-gray-500 mt-1">
                  URL-friendly identifier (lowercase, hyphens only)
                </p>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Price *
                  </label>
                  <input
                    type="number"
                    name="price"
                    value={formData.price}
                    onChange={handleInputChange}
                    required
                    step="0.01"
                    className="input"
                  />
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Currency *
                  </label>
                  <select
                    name="currency"
                    value={formData.currency}
                    onChange={handleInputChange}
                    required
                    className="input"
                  >
                    <option value="PKR">PKR</option>
                    <option value="USD">USD</option>
                    <option value="EUR">EUR</option>
                    <option value="GBP">GBP</option>
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Subtitle
                </label>
                <input
                  type="text"
                  name="subtitle"
                  value={formData.subtitle}
                  onChange={handleInputChange}
                  className="input"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Description
                </label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleInputChange}
                  rows={4}
                  className="input"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Video URL
                </label>
                <input
                  type="url"
                  name="video_url"
                  value={formData.video_url}
                  onChange={handleInputChange}
                  placeholder="https://www.youtube.com/watch?v=..."
                  className="input"
                />
                <p className="text-xs text-gray-500 mt-1">
                  YouTube or direct video URL
                </p>
              </div>

              <div className="flex items-center space-x-6">
                <label className="flex items-center">
                  <input
                    type="checkbox"
                    name="is_active"
                    checked={formData.is_active}
                    onChange={handleInputChange}
                    className="rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                  <span className="ml-2 text-sm text-gray-700">Active</span>
                </label>

                <label className="flex items-center">
                  <input
                    type="checkbox"
                    name="is_featured"
                    checked={formData.is_featured}
                    onChange={handleInputChange}
                    className="rounded border-gray-300 text-primary-600 focus:ring-primary-500"
                  />
                  <span className="ml-2 text-sm text-gray-700">Featured</span>
                </label>
              </div>

              <div className="flex justify-end space-x-3 pt-4 border-t">
                <button
                  type="button"
                  onClick={handleCloseModal}
                  className="btn-secondary"
                >
                  Cancel
                </button>
                <button
                  type="submit"
                  disabled={createMutation.isPending || updateMutation.isPending}
                  className="btn-primary"
                >
                  {createMutation.isPending || updateMutation.isPending
                    ? 'Saving...'
                    : editingItem
                    ? 'Update'
                    : 'Create'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
};

export default Packages;
