import { Link, useLocation } from 'react-router-dom';
import { useAuth } from '../utils/auth';
import {
  LayoutDashboard,
  Globe,
  FileText,
  Package,
  LogOut,
  Menu,
  X,
  User,
  ListChecks,
  Shield,
  Settings,
  CreditCard,
  ChevronDown,
  ChevronRight
} from 'lucide-react';
import { useState, useEffect } from 'react';

const Layout = ({ children }) => {
  const { user, logout } = useAuth();
  const location = useLocation();
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const [expandedSections, setExpandedSections] = useState({
    visa: true,
    validation: true,
    payments: true,
  });

  const navigation = [
    { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
    {
      name: 'Visa Management',
      icon: Globe,
      section: 'visa',
      children: [
        { name: 'Visa Types', href: '/visa-types', icon: Globe },
        { name: 'Visa Variants', href: '/visa-variants', icon: FileText },
        { name: 'Visa Rules', href: '/visa-rules', icon: ListChecks },
      ],
    },
    { name: 'Packages', href: '/packages', icon: Package },
    {
      name: 'Validation',
      icon: Shield,
      section: 'validation',
      children: [
        { name: 'Validation Schemas', href: '/validation-schemas', icon: Shield },
        { name: 'Field Rules', href: '/field-rules', icon: Settings },
      ],
    },
    {
      name: 'Payments',
      icon: CreditCard,
      section: 'payments',
      children: [
        { name: 'APG Transactions', href: '/apg-transactions', icon: CreditCard },
      ],
    },
  ];

  const isActive = (href) => location.pathname === href;

  const toggleSection = (section) => {
    setExpandedSections(prev => ({
      ...prev,
      [section]: !prev[section]
    }));
  };

  // Auto-expand section if user is on a child page
  useEffect(() => {
    navigation.forEach(item => {
      if (item.children) {
        const hasActiveChild = item.children.some(child => isActive(child.href));
        if (hasActiveChild && !expandedSections[item.section]) {
          setExpandedSections(prev => ({
            ...prev,
            [item.section]: true
          }));
        }
      }
    });
  }, [location.pathname]);

  return (
    <div className="min-h-screen bg-gray-50">
      {/* Mobile sidebar backdrop */}
      {sidebarOpen && (
        <div
          className="fixed inset-0 bg-black bg-opacity-50 z-40 lg:hidden"
          onClick={() => setSidebarOpen(false)}
        />
      )}

      {/* Sidebar */}
      <aside
        className={`fixed top-0 left-0 z-50 h-full w-64 bg-white border-r border-gray-200 transform transition-transform duration-300 ease-in-out ${
          sidebarOpen ? 'translate-x-0' : '-translate-x-full'
        } lg:translate-x-0`}
      >
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="flex items-center justify-between h-16 px-6 border-b border-gray-200">
            <h1 className="text-xl font-bold text-primary-900">Rehman Travels</h1>
            <button
              onClick={() => setSidebarOpen(false)}
              className="lg:hidden text-gray-500 hover:text-gray-700"
            >
              <X className="w-6 h-6" />
            </button>
          </div>

          {/* Navigation */}
          <nav className="flex-1 px-4 py-6 space-y-1 overflow-y-auto">
            {navigation.map((item) => {
              const Icon = item.icon;

              // If item has children, render as expandable section
              if (item.children) {
                const isExpanded = expandedSections[item.section];
                const hasActiveChild = item.children.some(child => isActive(child.href));

                return (
                  <div key={item.name} className="space-y-1">
                    <button
                      onClick={() => toggleSection(item.section)}
                      className={`w-full flex items-center justify-between px-4 py-3 rounded-lg font-medium transition-colors ${
                        hasActiveChild
                          ? 'bg-primary-50 text-primary-700'
                          : 'text-gray-700 hover:bg-gray-100'
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <Icon className="w-5 h-5" />
                        {item.name}
                      </div>
                      {isExpanded ? (
                        <ChevronDown className="w-4 h-4" />
                      ) : (
                        <ChevronRight className="w-4 h-4" />
                      )}
                    </button>

                    {/* Sub-items */}
                    {isExpanded && (
                      <div className="ml-4 space-y-1 border-l-2 border-gray-200 pl-2">
                        {item.children.map((child) => {
                          const ChildIcon = child.icon;
                          const childActive = isActive(child.href);

                          return (
                            <Link
                              key={child.name}
                              to={child.href}
                              onClick={() => setSidebarOpen(false)}
                              className={`flex items-center gap-3 px-4 py-2.5 rounded-lg text-sm font-medium transition-colors ${
                                childActive
                                  ? 'bg-primary-100 text-primary-800'
                                  : 'text-gray-600 hover:bg-gray-100 hover:text-gray-900'
                              }`}
                            >
                              <ChildIcon className="w-4 h-4" />
                              {child.name}
                            </Link>
                          );
                        })}
                      </div>
                    )}
                  </div>
                );
              }

              // Regular item without children
              const active = isActive(item.href);
              return (
                <Link
                  key={item.name}
                  to={item.href}
                  onClick={() => setSidebarOpen(false)}
                  className={`flex items-center gap-3 px-4 py-3 rounded-lg font-medium transition-colors ${
                    active
                      ? 'bg-primary-50 text-primary-700'
                      : 'text-gray-700 hover:bg-gray-100'
                  }`}
                >
                  <Icon className="w-5 h-5" />
                  {item.name}
                </Link>
              );
            })}
          </nav>

          {/* User info & logout */}
          <div className="p-4 border-t border-gray-200">
            <div className="flex items-center gap-3 px-4 py-3 bg-gray-50 rounded-lg mb-2">
              <div className="flex-shrink-0 w-8 h-8 bg-primary-600 rounded-full flex items-center justify-center">
                <User className="w-5 h-5 text-white" />
              </div>
              <div className="flex-1 min-w-0">
                <p className="text-sm font-medium text-gray-900 truncate">
                  {user?.username || 'User'}
                </p>
                <p className="text-xs text-gray-500 truncate">{user?.email || ''}</p>
              </div>
            </div>

            <button
              onClick={logout}
              className="w-full flex items-center gap-3 px-4 py-3 rounded-lg text-gray-700 hover:bg-red-50 hover:text-red-600 font-medium transition-colors"
            >
              <LogOut className="w-5 h-5" />
              Logout
            </button>
          </div>
        </div>
      </aside>

      {/* Main content */}
      <div className="lg:pl-64">
        {/* Top bar */}
        <header className="sticky top-0 z-30 bg-white border-b border-gray-200 h-16 flex items-center px-6">
          <button
            onClick={() => setSidebarOpen(true)}
            className="lg:hidden text-gray-500 hover:text-gray-700"
          >
            <Menu className="w-6 h-6" />
          </button>

          <div className="flex-1"></div>

          <div className="flex items-center gap-4">
            <span className="text-sm text-gray-600">
              Welcome, <strong>{user?.username}</strong>
            </span>
          </div>
        </header>

        {/* Page content */}
        <main className="p-6">{children}</main>
      </div>
    </div>
  );
};

export default Layout;
