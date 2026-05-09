import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { filterSortConfigAPI } from '../services/api';
import toast from 'react-hot-toast';
import { Plus, Edit2, Trash2, Search, X, CheckCircle, XCircle, Code, Eye } from 'lucide-react';

const FilterSortConfigs = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [isPreviewOpen, setIsPreviewOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [previewItem, setPreviewItem] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [jsonError, setJsonError] = useState('');
  const queryClient = useQueryClient();

  const [formData, setFormData] = useState({
    listing_name: '',
    config_data: '{}',
    version: '1.0',
    description: '',
    is_active: true,
  });

  // Fetch filter sort configs
  const { data: configs, isLoading } = useQuery({
    queryKey: ['filter-sort-configs', searchTerm],
    queryFn: async () => {
      const res = await filterSortConfigAPI.getAll({ search: searchTerm });
      return res.data?.results || [];
    },
  });

  // Create mutation
  const createMutation = useMutation({
    mutationFn: (data) => {
      const payload = {
        ...data,
        config_data: JSON.parse(data.config_data),
      };
      return filterSortConfigAPI.create(payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries(['filter-sort-configs']);
      toast.success('Filter config created successfully');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to create filter config');
    },
  });

  // Update mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }) => {
      const payload = {
        ...data,
        config_data: JSON.parse(data.config_data),
      };
      return filterSortConfigAPI.update(id, payload);
    },
    onSuccess: () => {
      queryClient.invalidateQueries(['filter-sort-configs']);
      toast.success('Filter config updated successfully');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to update filter config');
    },
  });

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: filterSortConfigAPI.delete,
    onSuccess: () => {
      queryClient.invalidateQueries(['filter-sort-configs']);
      toast.success('Filter config deleted successfully');
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to delete filter config');
    },
  });

  const handleOpenModal = (item = null) => {
    setJsonError('');
    if (item) {
      setEditingItem(item);
      setFormData({
        listing_name: item.listing_name || '',
        config_data: JSON.stringify(item.config_data || {}, null, 2),
        version: item.version || '1.0',
        description: item.description || '',
        is_active: item.is_active ?? true,
      });
    } else {
      setEditingItem(null);
      setFormData({
        listing_name: '',
        config_data: JSON.stringify({
          calculation_config: {
            factors: {},
            ranking_rules: {},
            tag_rules: [],
            filters: {},
          }
        }, null, 2),
        version: '1.0',
        description: '',
        is_active: true,
      });
    }
    setIsModalOpen(true);
  };

  const handleCloseModal = () => {
    setIsModalOpen(false);
    setEditingItem(null);
    setJsonError('');
  };

  const handleOpenPreview = (item) => {
    setPreviewItem(item);
    setIsPreviewOpen(true);
  };

  const handleClosePreview = () => {
    setIsPreviewOpen(false);
    setPreviewItem(null);
  };

  const validateJSON = (jsonString) => {
    try {
      JSON.parse(jsonString);
      setJsonError('');
      return true;
    } catch (e) {
      setJsonError(`Invalid JSON: ${e.message}`);
      return false;
    }
  };

  const handleSubmit = (e) => {
    e.preventDefault();

    if (!validateJSON(formData.config_data)) {
      return;
    }

    if (editingItem) {
      updateMutation.mutate({ id: editingItem.id, data: formData });
    } else {
      createMutation.mutate(formData);
    }
  };

  const handleDelete = (id) => {
    if (window.confirm('Are you sure you want to delete this filter configuration?')) {
      deleteMutation.mutate(id);
    }
  };

  const handleInputChange = (e) => {
    const { name, value, type, checked } = e.target;
    const newValue = type === 'checkbox' ? checked : value;

    setFormData(prev => ({
      ...prev,
      [name]: newValue
    }));

    // Validate JSON on change if it's the config_data field
    if (name === 'config_data') {
      validateJSON(newValue);
    }
  };

  const formatJSON = () => {
    try {
      const parsed = JSON.parse(formData.config_data);
      setFormData(prev => ({
        ...prev,
        config_data: JSON.stringify(parsed, null, 2)
      }));
      setJsonError('');
      toast.success('JSON formatted successfully');
    } catch (e) {
      toast.error('Cannot format invalid JSON');
    }
  };

  const getListingBadgeColor = (listing) => {
    const colors = {
      flights: 'bg-blue-100 text-blue-800',
      hotels: 'bg-purple-100 text-purple-800',
      umrah_packages: 'bg-green-100 text-green-800',
      visa: 'bg-orange-100 text-orange-800',
    };
    return colors[listing] || 'bg-gray-100 text-gray-800';
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">Filter & Sort Configurations</h1>
          <p className="text-gray-600 mt-1">Manage dynamic filter and sorting logic for listings</p>
        </div>
        <button
          onClick={() => handleOpenModal()}
          className="btn-primary"
        >
          <Plus className="h-5 w-5" />
          Add Configuration
        </button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
        <input
          type="text"
          placeholder="Search configurations..."
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
            <p className="text-gray-600 mt-4">Loading configurations...</p>
          </div>
        ) : configs?.length === 0 ? (
          <div className="p-8 text-center text-gray-500">
            <Code className="h-12 w-12 mx-auto mb-4 text-gray-400" />
            <p>No filter configurations found</p>
            <p className="text-sm mt-2">Create your first configuration to get started</p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Listing Type
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Version
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Description
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Updated
                  </th>
                  <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {configs?.map((config) => (
                  <tr key={config.id} className="hover:bg-gray-50">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <span className={`px-3 py-1 rounded-full text-xs font-medium ${getListingBadgeColor(config.listing_name)}`}>
                        {config.listing_display_name || config.listing_name}
                      </span>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-900">
                      v{config.version}
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-900">
                      <div className="max-w-xs truncate">
                        {config.description || '-'}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {config.is_active ? (
                        <span className="flex items-center text-green-600 text-sm">
                          <CheckCircle className="h-4 w-4 mr-1" />
                          Active
                        </span>
                      ) : (
                        <span className="flex items-center text-red-600 text-sm">
                          <XCircle className="h-4 w-4 mr-1" />
                          Inactive
                        </span>
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500">
                      {config.updated_at ? new Date(config.updated_at).toLocaleDateString() : '-'}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                      <div className="flex justify-end space-x-2">
                        <button
                          onClick={() => handleOpenPreview(config)}
                          className="text-blue-600 hover:text-blue-900"
                          title="Preview JSON"
                        >
                          <Eye className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => handleOpenModal(config)}
                          className="text-indigo-600 hover:text-indigo-900"
                          title="Edit"
                        >
                          <Edit2 className="h-5 w-5" />
                        </button>
                        <button
                          onClick={() => handleDelete(config.id)}
                          className="text-red-600 hover:text-red-900"
                          title="Delete"
                        >
                          <Trash2 className="h-5 w-5" />
                        </button>
                      </div>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Create/Edit Modal */}
      {isModalOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b border-gray-200">
              <div className="flex justify-between items-center">
                <h2 className="text-xl font-semibold text-gray-900">
                  {editingItem ? 'Edit Configuration' : 'Create Configuration'}
                </h2>
                <button
                  onClick={handleCloseModal}
                  className="text-gray-400 hover:text-gray-500"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
            </div>

            <form onSubmit={handleSubmit} className="p-6 space-y-6">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Listing Type *
                  </label>
                  <select
                    name="listing_name"
                    value={formData.listing_name}
                    onChange={handleInputChange}
                    className="input"
                    required
                    disabled={editingItem !== null}
                  >
                    <option value="">Select listing type</option>
                    <option value="flights">Flights</option>
                    <option value="hotels">Hotels</option>
                    <option value="umrah_packages">Umrah Packages</option>
                    <option value="visa">Visa</option>
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-2">
                    Version *
                  </label>
                  <input
                    type="text"
                    name="version"
                    value={formData.version}
                    onChange={handleInputChange}
                    className="input"
                    placeholder="e.g., 1.0, 2.1"
                    required
                  />
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-2">
                  Description
                </label>
                <textarea
                  name="description"
                  value={formData.description}
                  onChange={handleInputChange}
                  rows={2}
                  className="input"
                  placeholder="Brief description of this configuration..."
                />
              </div>

              <div>
                <div className="flex justify-between items-center mb-2">
                  <label className="block text-sm font-medium text-gray-700">
                    Configuration JSON *
                  </label>
                  <button
                    type="button"
                    onClick={formatJSON}
                    className="text-sm text-blue-600 hover:text-blue-800"
                  >
                    <Code className="h-4 w-4 inline mr-1" />
                    Format JSON
                  </button>
                </div>
                <textarea
                  name="config_data"
                  value={formData.config_data}
                  onChange={handleInputChange}
                  rows={20}
                  className={`input font-mono text-sm ${jsonError ? 'border-red-500' : ''}`}
                  placeholder='{"calculation_config": {...}}'
                  required
                />
                {jsonError && (
                  <p className="mt-2 text-sm text-red-600">{jsonError}</p>
                )}
              </div>

              <div className="flex items-center">
                <input
                  type="checkbox"
                  name="is_active"
                  checked={formData.is_active}
                  onChange={handleInputChange}
                  className="h-4 w-4 text-primary-600 focus:ring-primary-500 border-gray-300 rounded"
                />
                <label className="ml-2 block text-sm text-gray-900">
                  Active (Enable this configuration)
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
                  disabled={createMutation.isPending || updateMutation.isPending || jsonError}
                  className="btn-primary disabled:opacity-50"
                >
                  {editingItem ? 'Update' : 'Create'}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}

      {/* Preview Modal */}
      {isPreviewOpen && previewItem && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center p-4 z-50">
          <div className="bg-white rounded-lg max-w-4xl w-full max-h-[90vh] overflow-y-auto">
            <div className="p-6 border-b border-gray-200">
              <div className="flex justify-between items-center">
                <h2 className="text-xl font-semibold text-gray-900">
                  Configuration Preview: {previewItem.listing_display_name || previewItem.listing_name}
                </h2>
                <button
                  onClick={handleClosePreview}
                  className="text-gray-400 hover:text-gray-500"
                >
                  <X className="h-6 w-6" />
                </button>
              </div>
            </div>

            <div className="p-6">
              <div className="bg-gray-50 rounded-lg p-4">
                <pre className="text-sm text-gray-800 overflow-x-auto">
                  {JSON.stringify(previewItem.config_data, null, 2)}
                </pre>
              </div>
            </div>

            <div className="p-6 border-t border-gray-200">
              <button
                onClick={handleClosePreview}
                className="btn-secondary w-full"
              >
                Close
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default FilterSortConfigs;
