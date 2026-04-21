import { useQuery } from '@tanstack/react-query';
import { visaTypesAPI, visaVariantsAPI, packagesAPI } from '../services/api';
import { Globe, FileText, Package, TrendingUp } from 'lucide-react';

const Dashboard = () => {
  const { data: visaTypes } = useQuery({
    queryKey: ['visa-types'],
    queryFn: () => visaTypesAPI.getAll().then(res => {
      const data = res.data;
      return Array.isArray(data) ? data : (data?.results || []);
    }),
  });

  const { data: visaVariants } = useQuery({
    queryKey: ['visa-variants'],
    queryFn: () => visaVariantsAPI.getAll().then(res => {
      const data = res.data;
      return Array.isArray(data) ? data : (data?.results || []);
    }),
  });

  const { data: packages } = useQuery({
    queryKey: ['packages'],
    queryFn: () => packagesAPI.getAll().then(res => {
      const data = res.data;
      return Array.isArray(data) ? data : (data?.results || []);
    }),
  });

  const stats = [
    {
      name: 'Visa Types',
      value: Array.isArray(visaTypes) ? visaTypes.length : 0,
      icon: Globe,
      color: 'bg-blue-500',
      bgColor: 'bg-blue-50',
    },
    {
      name: 'Visa Variants',
      value: Array.isArray(visaVariants) ? visaVariants.length : 0,
      icon: FileText,
      color: 'bg-green-500',
      bgColor: 'bg-green-50',
    },
    {
      name: 'Packages',
      value: Array.isArray(packages) ? packages.length : 0,
      icon: Package,
      color: 'bg-purple-500',
      bgColor: 'bg-purple-50',
    },
    {
      name: 'Featured Items',
      value: (Array.isArray(visaVariants) ? visaVariants.filter(v => v.is_featured).length : 0) +
             (Array.isArray(packages) ? packages.filter(p => p.is_featured).length : 0),
      icon: TrendingUp,
      color: 'bg-orange-500',
      bgColor: 'bg-orange-50',
    },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900">Dashboard</h1>
        <p className="text-gray-600 mt-2">Welcome to Rehman Travels CMS</p>
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
            {Array.isArray(visaTypes) && visaTypes.slice(0, 5).map((type) => (
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
            {(!visaTypes || visaTypes.length === 0) && (
              <p className="text-gray-500 text-sm">No visa types found</p>
            )}
          </div>
        </div>

        {/* Recent Packages */}
        <div className="card">
          <h2 className="text-lg font-semibold text-gray-900 mb-4">Recent Packages</h2>
          <div className="space-y-3">
            {Array.isArray(packages) && packages.slice(0, 5).map((pkg) => (
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
            {(!packages || packages.length === 0) && (
              <p className="text-gray-500 text-sm">No packages found</p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default Dashboard;
