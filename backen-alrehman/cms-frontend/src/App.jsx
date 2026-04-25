import { Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider } from './utils/auth';
import ProtectedRoute from './components/ProtectedRoute';
import Layout from './components/Layout';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import VisaTypes from './pages/VisaTypes';
import VisaVariants from './pages/VisaVariants';
import VisaRules from './pages/VisaRules';
import Packages from './pages/Packages';
import ValidationSchemas from './pages/ValidationSchemas';
import FieldRules from './pages/FieldRules';
import APGTransactions from './pages/APGTransactions';

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
          path="/visa-rules"
          element={
            <ProtectedRoute>
              <Layout>
                <VisaRules />
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

        <Route
          path="/validation-schemas"
          element={
            <ProtectedRoute>
              <Layout>
                <ValidationSchemas />
              </Layout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/field-rules"
          element={
            <ProtectedRoute>
              <Layout>
                <FieldRules />
              </Layout>
            </ProtectedRoute>
          }
        />

        <Route
          path="/apg-transactions"
          element={
            <ProtectedRoute>
              <Layout>
                <APGTransactions />
              </Layout>
            </ProtectedRoute>
          }
        />
      </Routes>
    </AuthProvider>
  );
}

export default App;
