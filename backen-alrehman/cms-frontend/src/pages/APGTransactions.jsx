import { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { apgTransactionsAPI } from '../services/api';
import { Search, Eye, X, CheckCircle, XCircle, Clock, Ban } from 'lucide-react';

const APGTransactions = () => {
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedTransaction, setSelectedTransaction] = useState(null);
  const [statusFilter, setStatusFilter] = useState('all');

  // Fetch APG transactions
  const { data: transactions, isLoading } = useQuery({
    queryKey: ['apg-transactions', searchTerm, statusFilter],
    queryFn: async () => {
      const params = { search: searchTerm };
      if (statusFilter !== 'all') {
        params.transaction_status = statusFilter;
      }
      const res = await apgTransactionsAPI.getAll(params);
      return res.data?.results || [];
    },
    refetchInterval: 30000, // Auto-refresh every 30 seconds
  });

  const getStatusIcon = (status) => {
    switch (status) {
      case 'paid':
        return <CheckCircle className="h-5 w-5 text-green-600" />;
      case 'failed':
        return <XCircle className="h-5 w-5 text-red-600" />;
      case 'cancelled':
        return <Ban className="h-5 w-5 text-gray-600" />;
      case 'pending':
      default:
        return <Clock className="h-5 w-5 text-yellow-600" />;
    }
  };

  const getStatusBadge = (status) => {
    const styles = {
      paid: 'bg-green-100 text-green-800',
      failed: 'bg-red-100 text-red-800',
      cancelled: 'bg-gray-100 text-gray-800',
      pending: 'bg-yellow-100 text-yellow-800',
    };
    return styles[status] || styles.pending;
  };

  const formatDate = (dateString) => {
    if (!dateString) return 'N/A';
    return new Date(dateString).toLocaleString();
  };

  const formatAmount = (amount, currency) => {
    return `${currency} ${parseFloat(amount).toLocaleString(undefined, {
      minimumFractionDigits: 2,
      maximumFractionDigits: 2,
    })}`;
  };

  return (
    <div className="space-y-6">
      {/* Header */}
      <div className="flex justify-between items-center">
        <div>
          <h1 className="text-2xl font-bold text-gray-900">APG Transactions</h1>
          <p className="text-gray-600 mt-1">Monitor Alfa Payment Gateway transactions</p>
        </div>
        <div className="flex items-center gap-2 text-sm text-gray-600">
          <Clock className="h-4 w-4" />
          Auto-refreshes every 30s
        </div>
      </div>

      {/* Filters */}
      <div className="card">
        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
            <input
              type="text"
              placeholder="Search by ref, PNR, order ID..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="input pl-10"
            />
          </div>

          <div>
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="input"
            >
              <option value="all">All Statuses</option>
              <option value="pending">Pending</option>
              <option value="paid">Paid</option>
              <option value="failed">Failed</option>
              <option value="cancelled">Cancelled</option>
            </select>
          </div>
        </div>
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
                    Transaction Ref
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Booking PNR
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Amount
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Status
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Created
                  </th>
                  <th className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Actions
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {transactions?.length === 0 ? (
                  <tr>
                    <td colSpan="6" className="px-6 py-12 text-center text-gray-500">
                      No transactions found
                    </td>
                  </tr>
                ) : (
                  transactions?.map((item) => (
                    <tr key={item.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div className="text-sm font-medium text-gray-900">
                          {item.transaction_ref}
                        </div>
                        {item.order_id && (
                          <div className="text-xs text-gray-500">
                            Order: {item.order_id}
                          </div>
                        )}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900">
                        {item.booking_pnr || 'N/A'}
                      </td>
                      <td className="px-6 py-4 text-sm font-medium text-gray-900">
                        {formatAmount(item.amount, item.currency)}
                      </td>
                      <td className="px-6 py-4">
                        <div className="flex items-center gap-2">
                          {getStatusIcon(item.transaction_status)}
                          <span className={`px-2 py-1 text-xs font-semibold rounded-full ${getStatusBadge(item.transaction_status)}`}>
                            {item.transaction_status}
                          </span>
                        </div>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500">
                        {formatDate(item.created_at)}
                      </td>
                      <td className="px-6 py-4 text-right text-sm font-medium">
                        <button
                          onClick={() => setSelectedTransaction(item)}
                          className="text-primary-600 hover:text-primary-900"
                        >
                          <Eye className="h-4 w-4" />
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

      {/* Transaction Details Modal */}
      {selectedTransaction && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
          <div className="bg-white rounded-lg max-w-3xl w-full max-h-[90vh] overflow-y-auto">
            <div className="flex items-center justify-between p-6 border-b">
              <div>
                <h2 className="text-xl font-semibold">Transaction Details</h2>
                <p className="text-sm text-gray-500 mt-1">{selectedTransaction.transaction_ref}</p>
              </div>
              <button
                onClick={() => setSelectedTransaction(null)}
                className="text-gray-400 hover:text-gray-600"
              >
                <X className="h-6 w-6" />
              </button>
            </div>

            <div className="p-6 space-y-6">
              {/* Status & Amount */}
              <div className="grid grid-cols-2 gap-4">
                <div className="card bg-gray-50">
                  <div className="text-sm text-gray-600 mb-1">Status</div>
                  <div className="flex items-center gap-2">
                    {getStatusIcon(selectedTransaction.transaction_status)}
                    <span className={`px-3 py-1 text-sm font-semibold rounded-full ${getStatusBadge(selectedTransaction.transaction_status)}`}>
                      {selectedTransaction.transaction_status}
                    </span>
                  </div>
                </div>
                <div className="card bg-gray-50">
                  <div className="text-sm text-gray-600 mb-1">Amount</div>
                  <div className="text-2xl font-bold text-gray-900">
                    {formatAmount(selectedTransaction.amount, selectedTransaction.currency)}
                  </div>
                </div>
              </div>

              {/* Transaction Info */}
              <div className="space-y-3">
                <h3 className="font-semibold text-gray-900">Transaction Information</h3>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="text-gray-600">Transaction Ref:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.transaction_ref}</div>
                  </div>
                  <div>
                    <span className="text-gray-600">Order ID:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.order_id || 'N/A'}</div>
                  </div>
                  <div>
                    <span className="text-gray-600">APG Transaction ID:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.apg_transaction_id || 'N/A'}</div>
                  </div>
                  <div>
                    <span className="text-gray-600">Response Code:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.response_code || 'N/A'}</div>
                  </div>
                </div>
              </div>

              {/* Booking Info */}
              <div className="space-y-3">
                <h3 className="font-semibold text-gray-900">Booking Information</h3>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="text-gray-600">Booking PNR:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.booking_pnr || 'N/A'}</div>
                  </div>
                  <div>
                    <span className="text-gray-600">Booking Reference:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.booking_reference || 'N/A'}</div>
                  </div>
                  <div>
                    <span className="text-gray-600">Air Type:</span>
                    <div className="font-medium text-gray-900">{selectedTransaction.air_type || 'N/A'}</div>
                  </div>
                </div>
              </div>

              {/* Payment Details */}
              {(selectedTransaction.account_number || selectedTransaction.mobile_number) && (
                <div className="space-y-3">
                  <h3 className="font-semibold text-gray-900">Payment Details</h3>
                  <div className="grid grid-cols-2 gap-4 text-sm">
                    {selectedTransaction.account_number && (
                      <div>
                        <span className="text-gray-600">Account Number:</span>
                        <div className="font-medium text-gray-900">{selectedTransaction.account_number}</div>
                      </div>
                    )}
                    {selectedTransaction.mobile_number && (
                      <div>
                        <span className="text-gray-600">Mobile Number:</span>
                        <div className="font-medium text-gray-900">{selectedTransaction.mobile_number}</div>
                      </div>
                    )}
                  </div>
                </div>
              )}

              {/* Timestamps */}
              <div className="space-y-3">
                <h3 className="font-semibold text-gray-900">Timestamps</h3>
                <div className="grid grid-cols-2 gap-4 text-sm">
                  <div>
                    <span className="text-gray-600">Created At:</span>
                    <div className="font-medium text-gray-900">{formatDate(selectedTransaction.created_at)}</div>
                  </div>
                  <div>
                    <span className="text-gray-600">Updated At:</span>
                    <div className="font-medium text-gray-900">{formatDate(selectedTransaction.updated_at)}</div>
                  </div>
                  {selectedTransaction.order_datetime && (
                    <div>
                      <span className="text-gray-600">Order DateTime:</span>
                      <div className="font-medium text-gray-900">{selectedTransaction.order_datetime}</div>
                    </div>
                  )}
                  {selectedTransaction.transaction_datetime && (
                    <div>
                      <span className="text-gray-600">Transaction DateTime:</span>
                      <div className="font-medium text-gray-900">{selectedTransaction.transaction_datetime}</div>
                    </div>
                  )}
                </div>
              </div>

              {/* APG Response (if available) */}
              {selectedTransaction.apg_response && (
                <div className="space-y-3">
                  <h3 className="font-semibold text-gray-900">APG Response</h3>
                  <pre className="bg-gray-50 p-4 rounded-lg text-xs overflow-x-auto">
                    {JSON.stringify(selectedTransaction.apg_response, null, 2)}
                  </pre>
                </div>
              )}
            </div>

            <div className="flex justify-end p-6 border-t">
              <button
                onClick={() => setSelectedTransaction(null)}
                className="btn-secondary"
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

export default APGTransactions;
