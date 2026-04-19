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
