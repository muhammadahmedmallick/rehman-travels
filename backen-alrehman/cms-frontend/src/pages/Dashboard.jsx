import { useQuery, useQueryClient } from '@tanstack/react-query';
import { visaTypesAPI, visaVariantsAPI, packagesAPI } from '../services/api';
import { Globe, FileText, Package, TrendingUp, RefreshCw } from 'lucide-react';

const Dashboard = () => {
  const queryClient = useQueryClient();

  const handleRefresh = () => {
    console.log('🔄 Manual Refresh Triggered');
    queryClient.invalidateQueries({ queryKey: ['dashboard-visa-types'] });
    queryClient.invalidateQueries({ queryKey: ['dashboard-visa-variants'] });
    queryClient.invalidateQueries({ queryKey: ['dashboard-packages'] });
  };

  const { data: visaTypes = [], isLoading: loadingTypes, error: errorTypes } = useQuery({
    queryKey: ['dashboard-visa-types'],
    queryFn: async () => {
      console.log('🔵 Fetching Visa Types...');
      try {
        const res = await visaTypesAPI.getAll();
        console.log('✅ Visa Types Response:', res.data);
        console.log('✅ Visa Types Results:', res.data?.results);
        // API returns {count, next, previous, results: [...]}
        return res.data?.results || [];
      } catch (error) {
        console.error('❌ Visa Types Error:', error);
        throw error;
      }
    },
    staleTime: 0, // Always fetch fresh data
    cacheTime: 0, // Don't cache
  });

  const { data: visaVariants = [], isLoading: loadingVariants, error: errorVariants } = useQuery({
    queryKey: ['dashboard-visa-variants'],
    queryFn: async () => {
      console.log('🟢 Fetching Visa Variants...');
      try {
        const res = await visaVariantsAPI.getAll();
        console.log('✅ Visa Variants Response:', res.data);
        console.log('✅ Visa Variants Results:', res.data?.results);
        // API returns {count, next, previous, results: [...]}
        return res.data?.results || [];
      } catch (error) {
        console.error('❌ Visa Variants Error:', error);
        throw error;
      }
    },
    staleTime: 0, // Always fetch fresh data
    cacheTime: 0, // Don't cache
  });

  const { data: packages = [], isLoading: loadingPackages, error: errorPackages } = useQuery({
    queryKey: ['dashboard-packages'],
    queryFn: async () => {
      console.log('🟣 Fetching Packages...');
      try {
        const res = await packagesAPI.getAll();
        console.log('✅ Packages Response:', res.data);
        console.log('✅ Packages Results:', res.data?.results);
        // API returns {count, next, previous, results: [...]}
        return res.data?.results || [];
      } catch (error) {
        console.error('❌ Packages Error:', error);
        throw error;
      }
    },
    staleTime: 0, // Always fetch fresh data
    cacheTime: 0, // Don't cache
  });

  console.log('📊 Dashboard Data State:', {
    visaTypes: visaTypes?.length,
    visaVariants: visaVariants?.length,
    packages: packages?.length,
    loadingTypes,
    loadingVariants,
    loadingPackages,
    errorTypes: errorTypes?.message,
    errorVariants: errorVariants?.message,
    errorPackages: errorPackages?.message
  });

  const stats = [
    {
      name: 'Visa Types',
      value: visaTypes?.length || 0,
      icon: Globe,
      color: 'bg-blue-500',
      bgColor: 'bg-blue-50',
    },
    {
      name: 'Visa Variants',
      value: visaVariants?.length || 0,
      icon: FileText,
      color: 'bg-green-500',
      bgColor: 'bg-green-50',
    },
    {
      name: 'Packages',
      value: packages?.length || 0,
      icon: Package,
      color: 'bg-purple-500',
      bgColor: 'bg-purple-50',
    },
    {
      name: 'Featured Items',
      value: (visaVariants?.filter(v => v?.is_featured)?.length || 0) +
             (packages?.filter(p => p?.is_featured)?.length || 0),
      icon: TrendingUp,
      color: 'bg-orange-500',
      bgColor: 'bg-orange-50',
    },
  ];

  const isLoading = loadingTypes || loadingVariants || loadingPackages;
  const hasError = errorTypes || errorVariants || errorPackages;

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
          <p className="text-gray-600 mt-2">Welcome to Rehman Travels CMS</p>
        </div>
        <button
          onClick={handleRefresh}
          disabled={isLoading}
          className="btn-primary"
        >
          <RefreshCw className={`h-5 w-5 ${isLoading ? 'animate-spin' : ''}`} />
          Refresh Data
        </button>
      </div>

      {/* Loading State */}
      {isLoading && (
        <div className="bg-blue-50 border border-blue-200 rounded-lg p-4">
          <div className="flex items-center gap-3">
            <div className="animate-spin rounded-full h-5 w-5 border-b-2 border-blue-600"></div>
            <span className="text-blue-800">Loading dashboard data...</span>
          </div>
        </div>
      )}

      {/* Error State */}
      {hasError && (
        <div className="bg-red-50 border border-red-200 rounded-lg p-4">
          <p className="text-red-800 font-medium">Error loading data:</p>
          <p className="text-red-600 text-sm mt-1">
            {errorTypes?.message || errorVariants?.message || errorPackages?.message}
          </p>
        </div>
      )}

      {/* Debug Info (temporary) */}
      <div className="bg-yellow-50 border border-yellow-200 rounded-lg p-4 text-xs">
        <p className="font-bold text-yellow-900 mb-2">🔍 Debug Info:</p>
        <div className="grid grid-cols-3 gap-4">
          <div>
            <span className="font-semibold">Visa Types:</span> {visaTypes?.length} items
            {visaTypes?.length > 0 && <span className="ml-2 text-green-600">✓</span>}
          </div>
          <div>
            <span className="font-semibold">Visa Variants:</span> {visaVariants?.length} items
            {visaVariants?.length > 0 && <span className="ml-2 text-green-600">✓</span>}
          </div>
          <div>
            <span className="font-semibold">Packages:</span> {packages?.length} items
            {packages?.length > 0 && <span className="ml-2 text-green-600">✓</span>}
          </div>
        </div>
        <p className="mt-2 text-yellow-700">Check browser console (F12) for detailed API responses</p>
      </div>

      {/* Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat) => {
          const Icon = stat.icon;
          return (
            <div key={stat.name} className="card">
              <div className="flex items-center justify-between">
                <div>
                  <p className="text-sm font-medium text-gray-600">{stat.name}</p>
                  <p className="text-3xl font-bold text-gray-900 mt-2">{stat.value}</p>
                </div>
                <div className={`${stat.bgColor} p-3 rounded-lg`}>
                  <Icon className={`w-8 h-8 ${stat.color.replace('bg-', 'text-')}`} />
                </div>
              </div>
            </div>
          );
        })}
      </div>

      {/* Recent Activity */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        {/* Recent Visa Types */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Visa Types</h2>
          <div className="space-y-3">
            {visaTypes?.slice(0, 5)?.map((type) => (
              <div key={type.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{type.title}</p>
                  <p className="text-sm text-gray-600">{type.country_code}</p>
                </div>
                <span className={`px-2 py-1 text-xs font-medium rounded ${
                  type.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                }`}>
                  {type.is_active ? 'Active' : 'Inactive'}
                </span>
              </div>
            ))}
            {visaTypes?.length === 0 && (
              <p className="text-gray-500 text-sm">No visa types found</p>
            )}
          </div>
        </div>

        {/* Recent Packages */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Packages</h2>
          <div className="space-y-3">
            {packages?.slice(0, 5)?.map((pkg) => (
              <div key={pkg.id} className="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900">{pkg.title}</p>
                  <p className="text-sm text-gray-600">{pkg.formatted_price}</p>
                </div>
                <div className="flex gap-2">
                  {pkg.is_featured && (
                    <span className="px-2 py-1 text-xs font-medium rounded bg-yellow-100 text-yellow-800">
                      Featured
                    </span>
                  )}
                  <span className={`px-2 py-1 text-xs font-medium rounded ${
                    pkg.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                  }`}>
                    {pkg.is_active ? 'Active' : 'Inactive'}
                  </span>
                </div>
              </div>
            ))}
            {packages?.length === 0 && (
              <p className="text-gray-500 text-sm">No packages found</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
