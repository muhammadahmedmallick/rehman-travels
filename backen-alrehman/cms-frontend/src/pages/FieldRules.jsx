import { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { fieldRulesAPI, validationSchemasAPI } from '../services/api';
import toast from 'react-hot-toast';
import { Plus, Edit2, Trash2, Search, X, CheckCircle, XCircle, ChevronDown, ChevronUp } from 'lucide-react';

const RULE_TYPES = [
  { value: 'required', label: 'Required' },
  { value: 'min_length', label: 'Minimum Length' },
  { value: 'max_length', label: 'Maximum Length' },
  { value: 'regex', label: 'Regex Pattern' },
  { value: 'email', label: 'Valid Email' },
  { value: 'phone', label: 'Valid Phone' },
  { value: 'numeric', label: 'Numeric Only' },
  { value: 'min_value', label: 'Minimum Value' },
  { value: 'max_value', label: 'Maximum Value' },
  { value: 'in_choices', label: 'Allowed Choices' },
  { value: 'max_decimal', label: 'Max Decimal Places' },
  { value: 'boolean', label: 'Boolean' },
];

const ERROR_CODES = [
  { value: 'FIELD_REQUIRED', label: 'Field Required' },
  { value: 'MIN_LENGTH', label: 'Min Length Violation' },
  { value: 'MAX_LENGTH', label: 'Max Length Violation' },
  { value: 'REGEX_MISMATCH', label: 'Regex Mismatch' },
  { value: 'INVALID_EMAIL', label: 'Invalid Email' },
  { value: 'INVALID_PHONE', label: 'Invalid Phone' },
  { value: 'NUMERIC_ONLY', label: 'Numeric Only' },
  { value: 'MIN_VALUE', label: 'Min Value Violation' },
  { value: 'MAX_VALUE', label: 'Max Value Violation' },
  { value: 'INVALID_CHOICE', label: 'Invalid Choice' },
  { value: 'MAX_DECIMAL', label: 'Max Decimal Violation' },
  { value: 'INVALID_BOOLEAN', label: 'Invalid Boolean' },
];

const RULE_VALUE_EXAMPLES = {
  required: {
    needsValue: false,
    description: 'This rule checks if the field has a value. Leave Rule Value blank.',
    examples: [
      { value: '', label: 'Leave blank - no value needed', use: 'For any required field' },
    ],
  },
  min_length: {
    needsValue: true,
    description: 'Minimum number of characters required in the field.',
    examples: [
      { value: '3', label: '3', use: 'Username must be at least 3 characters' },
      { value: '6', label: '6', use: 'Password must be at least 6 characters' },
      { value: '8', label: '8', use: 'Strong password (8+ chars)' },
      { value: '10', label: '10', use: 'Phone number minimum length' },
      { value: '2', label: '2', use: 'Name fields (at least 2 letters)' },
    ],
  },
  max_length: {
    needsValue: true,
    description: 'Maximum number of characters allowed in the field.',
    examples: [
      { value: '50', label: '50', use: 'Name fields (max 50 chars)' },
      { value: '100', label: '100', use: 'Email address (max 100 chars)' },
      { value: '255', label: '255', use: 'General text fields' },
      { value: '15', label: '15', use: 'Phone number max length' },
      { value: '1000', label: '1000', use: 'Description or comment fields' },
      { value: '20', label: '20', use: 'Username max length' },
    ],
  },
  regex: {
    needsValue: true,
    description: 'Regular expression pattern that the value must match.',
    examples: [
      { value: '^[A-Za-z]+$', label: '^[A-Za-z]+$', use: 'Only letters (no numbers/spaces)' },
      { value: '^[A-Za-z ]+$', label: '^[A-Za-z ]+$', use: 'Letters and spaces only' },
      { value: '^[0-9]+$', label: '^[0-9]+$', use: 'Only digits' },
      { value: '^03[0-9]{9}$', label: '^03[0-9]{9}$', use: 'Pakistani mobile (03xxxxxxxxx)' },
      { value: '^[A-Z0-9]{6}$', label: '^[A-Z0-9]{6}$', use: 'PNR code (6 uppercase/digits)' },
      { value: '^[a-z0-9_]+$', label: '^[a-z0-9_]+$', use: 'Username (lowercase, numbers, underscore)' },
      { value: '^\\d{5}$', label: '^\\d{5}$', use: 'Zip code (5 digits)' },
      { value: '^[A-Z]{2}[0-9]{4}$', label: '^[A-Z]{2}[0-9]{4}$', use: 'Passport format (AB1234)' },
    ],
  },
  email: {
    needsValue: false,
    description: 'Validates if the value is a proper email address. Leave Rule Value blank.',
    examples: [
      { value: '', label: 'Leave blank - no value needed', use: 'Validates email@example.com format' },
    ],
  },
  phone: {
    needsValue: false,
    description: 'Validates if the value is a valid phone number. Leave Rule Value blank.',
    examples: [
      { value: '', label: 'Leave blank - no value needed', use: 'Validates phone number format' },
    ],
  },
  numeric: {
    needsValue: false,
    description: 'Checks if the value contains only numeric digits. Leave Rule Value blank.',
    examples: [
      { value: '', label: 'Leave blank - no value needed', use: 'For ID numbers, quantity, age, etc.' },
    ],
  },
  min_value: {
    needsValue: true,
    description: 'Minimum numeric value allowed.',
    examples: [
      { value: '0', label: '0', use: 'No negative values (price, quantity)' },
      { value: '1', label: '1', use: 'At least 1 (passenger count, items)' },
      { value: '18', label: '18', use: 'Minimum age requirement' },
      { value: '100', label: '100', use: 'Minimum payment amount (PKR 100)' },
      { value: '1000', label: '1000', use: 'Minimum booking amount' },
      { value: '0.01', label: '0.01', use: 'Must be greater than zero' },
    ],
  },
  max_value: {
    needsValue: true,
    description: 'Maximum numeric value allowed.',
    examples: [
      { value: '10', label: '10', use: 'Maximum passengers per booking' },
      { value: '100', label: '100', use: 'Maximum age' },
      { value: '999999', label: '999999', use: 'Maximum amount (less than 1 million)' },
      { value: '50', label: '50', use: 'Maximum items in cart' },
      { value: '365', label: '365', use: 'Maximum days in advance' },
    ],
  },
  in_choices: {
    needsValue: true,
    description: 'Comma-separated list of allowed values. Value must match one of these exactly.',
    examples: [
      { value: 'PKR,USD,EUR,GBP', label: 'PKR,USD,EUR,GBP', use: 'Currency selection' },
      { value: 'male,female,other', label: 'male,female,other', use: 'Gender options' },
      { value: 'economy,business,first', label: 'economy,business,first', use: 'Flight class' },
      { value: 'pending,confirmed,cancelled', label: 'pending,confirmed,cancelled', use: 'Booking status' },
      { value: 'credit_card,debit_card,bank_transfer,cash', label: 'credit_card,debit_card,bank_transfer,cash', use: 'Payment methods' },
      { value: 'karachi,lahore,islamabad,peshawar', label: 'karachi,lahore,islamabad,peshawar', use: 'City selection' },
      { value: 'mr,mrs,ms,dr', label: 'mr,mrs,ms,dr', use: 'Title/salutation' },
    ],
  },
  max_decimal: {
    needsValue: true,
    description: 'Maximum number of decimal places allowed in a numeric value.',
    examples: [
      { value: '2', label: '2', use: 'Money amounts (e.g., 1500.99)' },
      { value: '0', label: '0', use: 'Whole numbers only (no decimals)' },
      { value: '3', label: '3', use: 'Precise measurements (e.g., 12.345)' },
      { value: '4', label: '4', use: 'Exchange rates (e.g., 278.4567)' },
    ],
  },
  boolean: {
    needsValue: false,
    description: 'Validates if the value is a boolean (true/false, 1/0, yes/no). Leave Rule Value blank.',
    examples: [
      { value: '', label: 'Leave blank - no value needed', use: 'For checkboxes, toggles, yes/no fields' },
    ],
  },
};

const FieldRules = () => {
  const [isModalOpen, setIsModalOpen] = useState(false);
  const [editingItem, setEditingItem] = useState(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [showHelp, setShowHelp] = useState(false);
  const queryClient = useQueryClient();

  const [formData, setFormData] = useState({
    schema: '',
    field_name: '',
    rule_type: 'required',
    rule_value: '',
    error_code: 'FIELD_REQUIRED',
    error_message: '',
    order: 10,
    is_active: true,
  });

  // Fetch field rules
  const { data: rules, isLoading } = useQuery({
    queryKey: ['field-rules', searchTerm],
    queryFn: async () => {
      const res = await fieldRulesAPI.getAll({ search: searchTerm });
      return res.data?.results || [];
    },
  });

  // Fetch validation schemas for dropdown
  const { data: schemas } = useQuery({
    queryKey: ['validation-schemas'],
    queryFn: async () => {
      const res = await validationSchemasAPI.getAll();
      return res.data?.results || [];
    },
  });

  // Create mutation
  const createMutation = useMutation({
    mutationFn: fieldRulesAPI.create,
    onSuccess: () => {
      queryClient.invalidateQueries(['field-rules']);
      toast.success('Field rule created successfully');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to create field rule');
    },
  });

  // Update mutation
  const updateMutation = useMutation({
    mutationFn: ({ id, data }) => fieldRulesAPI.update(id, data),
    onSuccess: () => {
      queryClient.invalidateQueries(['field-rules']);
      toast.success('Field rule updated successfully');
      handleCloseModal();
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to update field rule');
    },
  });

  // Delete mutation
  const deleteMutation = useMutation({
    mutationFn: fieldRulesAPI.delete,
    onSuccess: () => {
      queryClient.invalidateQueries(['field-rules']);
      toast.success('Field rule deleted successfully');
    },
    onError: (error) => {
      toast.error(error.response?.data?.message || 'Failed to delete field rule');
    },
  });

  const handleOpenModal = (item = null) => {
    if (item) {
      setEditingItem(item);
      setFormData({
        schema: item.schema || '',
        field_name: item.field_name || '',
        rule_type: item.rule_type || 'required',
        rule_value: item.rule_value || '',
        error_code: item.error_code || 'FIELD_REQUIRED',
        error_message: item.error_message || '',
        order: item.order ?? 10,
        is_active: item.is_active ?? true,
      });
    } else {
      setEditingItem(null);
      setFormData({
        schema: '',
        field_name: '',
        rule_type: 'required',
        rule_value: '',
        error_code: 'FIELD_REQUIRED',
        error_message: '',
        order: 10,
        is_active: true,
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
      updateMutation.mutate({ id: editingItem.id, data: formData });
    } else {
      createMutation.mutate(formData);
    }
  };

  const handleDelete = (id) => {
    if (window.confirm('Are you sure you want to delete this field rule?')) {
      deleteMutation.mutate(id);
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
          <h1 className="text-2xl font-bold text-gray-900">Field Rules</h1>
          <p className="text-gray-600 mt-1">Define validation rules for schema fields</p>
        </div>
        <button
          onClick={() => handleOpenModal()}
          className="btn-primary"
        >
          <Plus className="h-5 w-5" />
          Add Field Rule
        </button>
      </div>

      {/* Search */}
      <div className="relative">
        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
        <input
          type="text"
          placeholder="Search field rules..."
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
                    Field Name
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Rule Type
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Rule Value
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Error Code
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">
                    Order
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
                {rules?.length === 0 ? (
                  <tr>
                    <td colSpan="7" className="px-6 py-12 text-center text-gray-500">
                      No field rules found
                    </td>
                  </tr>
                ) : (
                  rules?.map((item) => (
                    <tr key={item.id} className="hover:bg-gray-50">
                      <td className="px-6 py-4">
                        <div className="text-sm font-medium text-gray-900">
                          {item.field_name}
                        </div>
                      </td>
                      <td className="px-6 py-4">
                        <span className="px-2 py-1 text-xs font-semibold rounded-full bg-blue-100 text-blue-800">
                          {item.rule_type}
                        </span>
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500">
                        {item.rule_value || '-'}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-500">
                        {item.error_code}
                      </td>
                      <td className="px-6 py-4 text-sm text-gray-900">
                        {item.order}
                      </td>
                      <td className="px-6 py-4">
                        {item.is_active ? (
                          <CheckCircle className="h-5 w-5 text-green-600" />
                        ) : (
                          <XCircle className="h-5 w-5 text-gray-400" />
                        )}
                      </td>
                      <td className="px-6 py-4 text-right text-sm font-medium">
                        <button
                          onClick={() => handleOpenModal(item)}
                          className="text-primary-600 hover:text-primary-900 mr-4"
                        >
                          <Edit2 className="h-4 w-4" />
                        </button>
                        <button
                          onClick={() => handleDelete(item.id)}
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
                {editingItem ? 'Edit Field Rule' : 'Add Field Rule'}
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
                  Schema *
                </label>
                <select
                  name="schema"
                  value={formData.schema}
                  onChange={handleInputChange}
                  required
                  className="input"
                >
                  <option value="">Select schema</option>
                  {schemas?.map((schema) => (
                    <option key={schema.id} value={schema.id}>
                      {schema.schema_type}
                    </option>
                  ))}
                </select>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Field Name *
                </label>
                <input
                  type="text"
                  name="field_name"
                  value={formData.field_name}
                  onChange={handleInputChange}
                  required
                  placeholder="e.g., name, amount, email"
                  className="input"
                />
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Rule Type *
                  </label>
                  <select
                    name="rule_type"
                    value={formData.rule_type}
                    onChange={handleInputChange}
                    required
                    className="input"
                  >
                    {RULE_TYPES.map((type) => (
                      <option key={type.value} value={type.value}>
                        {type.label}
                      </option>
                    ))}
                  </select>
                </div>

                <div>
                  <label className="block text-sm font-medium text-gray-700 mb-1">
                    Error Code *
                  </label>
                  <select
                    name="error_code"
                    value={formData.error_code}
                    onChange={handleInputChange}
                    required
                    className="input"
                  >
                    {ERROR_CODES.map((code) => (
                      <option key={code.value} value={code.value}>
                        {code.label}
                      </option>
                    ))}
                  </select>
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Rule Value
                </label>
                <input
                  type="text"
                  name="rule_value"
                  value={formData.rule_value}
                  onChange={handleInputChange}
                  placeholder="e.g., 6 (for min_length), PKR,USD,EUR (for in_choices)"
                  className="input"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Required for min/max length/value, regex, in_choices, max_decimal
                </p>

                {/* Help Section - Examples & Descriptions */}
                <div className="mt-3 border border-gray-200 rounded-lg overflow-hidden">
                  <button
                    type="button"
                    onClick={() => setShowHelp(!showHelp)}
                    className="w-full flex items-center justify-between px-4 py-3 bg-blue-50 hover:bg-blue-100 transition-colors"
                  >
                    <div className="flex items-center gap-2">
                      {showHelp ? (
                        <ChevronUp className="h-5 w-5 text-blue-600" />
                      ) : (
                        <ChevronDown className="h-5 w-5 text-blue-600" />
                      )}
                      <span className="text-sm font-medium text-blue-900">
                        📚 View Examples & Quick Reference Guide
                      </span>
                    </div>
                    <span className="text-xs text-blue-700 px-2 py-1 bg-blue-200 rounded">
                      {RULE_VALUE_EXAMPLES[formData.rule_type]?.needsValue ? '⚠️ Value Required' : '✓ No Value Needed'}
                    </span>
                  </button>

                  {showHelp && (
                    <div className="p-4 bg-white border-t border-gray-200 max-h-[500px] overflow-y-auto">
                      <div className="space-y-6">
                        {/* Current Rule Type Section */}
                        <div className="bg-blue-50 p-4 rounded-lg border-2 border-blue-200">
                          <h3 className="text-base font-bold text-blue-900 mb-3 flex items-center gap-2">
                            <span className="text-xl">🎯</span>
                            Current Rule: {RULE_TYPES.find(t => t.value === formData.rule_type)?.label}
                          </h3>

                          {/* Description */}
                          <div className="mb-3">
                            <h4 className="text-sm font-semibold text-gray-900 mb-1">
                              📋 Description
                            </h4>
                            <p className="text-sm text-gray-700">
                              {RULE_VALUE_EXAMPLES[formData.rule_type]?.description}
                            </p>
                          </div>

                          {/* Examples */}
                          <div>
                            <h4 className="text-sm font-semibold text-gray-900 mb-2">
                              💡 Examples for {RULE_TYPES.find(t => t.value === formData.rule_type)?.label}
                            </h4>
                            <div className="space-y-2">
                              {RULE_VALUE_EXAMPLES[formData.rule_type]?.examples.map((example, idx) => (
                                <div
                                  key={idx}
                                  className="flex items-start gap-3 p-3 bg-white rounded-lg hover:bg-gray-50 transition-colors border border-gray-200"
                                >
                                  <div className="flex-shrink-0 w-6 h-6 bg-blue-500 text-white rounded-full flex items-center justify-center text-xs font-bold">
                                    {idx + 1}
                                  </div>
                                  <div className="flex-1 min-w-0">
                                    <div className="flex items-center gap-2 mb-1 flex-wrap">
                                      <code className="px-2 py-1 bg-yellow-50 border border-yellow-300 rounded text-xs font-mono text-gray-900 font-bold">
                                        {example.value || '(leave blank)'}
                                      </code>
                                      {example.value && (
                                        <button
                                          type="button"
                                          onClick={() => setFormData(prev => ({ ...prev, rule_value: example.value }))}
                                          className="text-xs bg-blue-600 text-white px-3 py-1 rounded hover:bg-blue-700 font-medium"
                                        >
                                          ✓ Use this
                                        </button>
                                      )}
                                    </div>
                                    <p className="text-xs text-gray-600">
                                      ➜ {example.use}
                                    </p>
                                  </div>
                                </div>
                              ))}
                            </div>
                          </div>

                          {/* Tips */}
                          <div className="mt-4 pt-3 border-t border-blue-200">
                            <h4 className="text-sm font-semibold text-gray-900 mb-2">
                              💭 Pro Tips
                            </h4>
                            <ul className="text-xs text-gray-700 space-y-1 list-disc list-inside">
                              {formData.rule_type === 'required' && (
                                <>
                                  <li>This rule doesn't need a value - it just checks if the field exists</li>
                                  <li>Combine with other rules like min_length for stronger validation</li>
                                </>
                              )}
                              {formData.rule_type === 'min_length' && (
                                <>
                                  <li>Common values: 3 for usernames, 6-8 for passwords, 2 for names</li>
                                  <li>Enter only the number, not "characters" or other text</li>
                                </>
                              )}
                              {formData.rule_type === 'max_length' && (
                                <>
                                  <li>Database limits: varchar(255) is common, use 255 as max</li>
                                  <li>For names use 50, emails use 100, descriptions use 500-1000</li>
                                </>
                              )}
                              {formData.rule_type === 'regex' && (
                                <>
                                  <li>Test your regex pattern before using it in production</li>
                                  <li>Use ^ for start and $ for end to match the entire string</li>
                                  <li>Common patterns: [A-Z] uppercase, [a-z] lowercase, [0-9] digits, . any char</li>
                                </>
                              )}
                              {formData.rule_type === 'in_choices' && (
                                <>
                                  <li>Separate choices with commas (,) with no spaces</li>
                                  <li>Values are case-sensitive: "PKR" is different from "pkr"</li>
                                  <li>Keep choices short and consistent (lowercase recommended)</li>
                                </>
                              )}
                              {formData.rule_type === 'min_value' && (
                                <>
                                  <li>Use 0 to prevent negative numbers</li>
                                  <li>Use 1 for counts that can't be zero (passengers, items)</li>
                                  <li>Decimals allowed: use 0.01 to require values greater than zero</li>
                                </>
                              )}
                              {formData.rule_type === 'max_value' && (
                                <>
                                  <li>Set realistic limits based on your business rules</li>
                                  <li>Consider database column limits (INT max is 2147483647)</li>
                                </>
                              )}
                              {formData.rule_type === 'max_decimal' && (
                                <>
                                  <li>Use 2 for money (PKR, USD, EUR)</li>
                                  <li>Use 0 for whole numbers only</li>
                                  <li>Use 3-4 for exchange rates or precise calculations</li>
                                </>
                              )}
                              {(formData.rule_type === 'email' || formData.rule_type === 'phone' || formData.rule_type === 'numeric' || formData.rule_type === 'boolean') && (
                                <>
                                  <li>This rule validates automatically - no value needed</li>
                                  <li>Leave the Rule Value field empty</li>
                                </>
                              )}
                            </ul>
                          </div>
                        </div>

                        {/* Quick Reference for ALL Rule Types */}
                        <div className="border-t-2 border-gray-300 pt-4">
                          <h3 className="text-base font-bold text-gray-900 mb-3 flex items-center gap-2">
                            <span className="text-xl">📖</span>
                            Quick Reference - All Rule Types
                          </h3>

                          <div className="space-y-4">
                            {/* String Length Rules */}
                            <div className="bg-green-50 p-3 rounded-lg border border-green-200">
                              <h4 className="font-semibold text-green-900 mb-2 text-sm">📏 String Length Rules</h4>
                              <div className="space-y-2 text-xs">
                                <div className="bg-white p-2 rounded border border-green-200">
                                  <strong>min_length:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">6</code> → Password minimum 6 chars
                                </div>
                                <div className="bg-white p-2 rounded border border-green-200">
                                  <strong>max_length:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">50</code> → Name maximum 50 chars
                                </div>
                              </div>
                            </div>

                            {/* Numeric Rules */}
                            <div className="bg-purple-50 p-3 rounded-lg border border-purple-200">
                              <h4 className="font-semibold text-purple-900 mb-2 text-sm">🔢 Numeric Rules</h4>
                              <div className="space-y-2 text-xs">
                                <div className="bg-white p-2 rounded border border-purple-200">
                                  <strong>min_value:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">1</code> → At least 1 passenger
                                </div>
                                <div className="bg-white p-2 rounded border border-purple-200">
                                  <strong>max_value:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">10</code> → Maximum 10 passengers
                                </div>
                                <div className="bg-white p-2 rounded border border-purple-200">
                                  <strong>max_decimal:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">2</code> → Money (e.g., 1500.99)
                                </div>
                              </div>
                            </div>

                            {/* Regex Patterns */}
                            <div className="bg-orange-50 p-3 rounded-lg border border-orange-200">
                              <h4 className="font-semibold text-orange-900 mb-2 text-sm">🎯 Regex Patterns (Test Strings)</h4>
                              <div className="space-y-2 text-xs">
                                <div className="bg-white p-2 rounded border border-orange-200">
                                  <strong>Letters only:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">^[A-Za-z]+$</code><br/>
                                  <span className="text-green-700">✓ Valid: "Ahmed", "John"</span><br/>
                                  <span className="text-red-700">✗ Invalid: "Ahmed123", "A-B"</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-orange-200">
                                  <strong>Letters + spaces:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">^[A-Za-z ]+$</code><br/>
                                  <span className="text-green-700">✓ Valid: "Muhammad Ahmed", "John Doe"</span><br/>
                                  <span className="text-red-700">✗ Invalid: "Ahmed-123", "A.B"</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-orange-200">
                                  <strong>Pakistani mobile:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">^03[0-9]{'{9}'}$</code><br/>
                                  <span className="text-green-700">✓ Valid: "03001234567", "03331234567"</span><br/>
                                  <span className="text-red-700">✗ Invalid: "3001234567", "0300-1234567"</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-orange-200">
                                  <strong>PNR code (6 chars):</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">^[A-Z0-9]{'{6}'}$</code><br/>
                                  <span className="text-green-700">✓ Valid: "ABC123", "XYZ789", "A1B2C3"</span><br/>
                                  <span className="text-red-700">✗ Invalid: "abc123", "AB123", "ABCDEFG"</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-orange-200">
                                  <strong>Username (lowercase):</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">^[a-z0-9_]+$</code><br/>
                                  <span className="text-green-700">✓ Valid: "john_doe", "user123", "ahmad_ali"</span><br/>
                                  <span className="text-red-700">✗ Invalid: "John_Doe", "user-123", "user@name"</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-orange-200">
                                  <strong>Only digits:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">^[0-9]+$</code><br/>
                                  <span className="text-green-700">✓ Valid: "123", "456789", "0"</span><br/>
                                  <span className="text-red-700">✗ Invalid: "12.3", "abc", "12-34"</span>
                                </div>
                              </div>
                            </div>

                            {/* Choices */}
                            <div className="bg-blue-50 p-3 rounded-lg border border-blue-200">
                              <h4 className="font-semibold text-blue-900 mb-2 text-sm">📋 Choice Lists</h4>
                              <div className="space-y-2 text-xs">
                                <div className="bg-white p-2 rounded border border-blue-200">
                                  <strong>Currency:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">PKR,USD,EUR,GBP</code><br/>
                                  <span className="text-gray-600">User must enter exactly: PKR OR USD OR EUR OR GBP</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-blue-200">
                                  <strong>Gender:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">male,female,other</code><br/>
                                  <span className="text-gray-600">User must enter: male OR female OR other</span>
                                </div>
                                <div className="bg-white p-2 rounded border border-blue-200">
                                  <strong>Status:</strong> <code className="bg-yellow-100 px-2 py-0.5 rounded">pending,confirmed,cancelled</code><br/>
                                  <span className="text-gray-600">Only these 3 values allowed</span>
                                </div>
                              </div>
                            </div>

                            {/* No Value Rules */}
                            <div className="bg-gray-50 p-3 rounded-lg border border-gray-300">
                              <h4 className="font-semibold text-gray-900 mb-2 text-sm">✓ Rules That Don't Need Values</h4>
                              <div className="space-y-1 text-xs">
                                <div className="bg-white p-2 rounded border border-gray-200">
                                  <strong>required:</strong> Leave blank - just checks field exists
                                </div>
                                <div className="bg-white p-2 rounded border border-gray-200">
                                  <strong>email:</strong> Leave blank - validates email@domain.com
                                </div>
                                <div className="bg-white p-2 rounded border border-gray-200">
                                  <strong>phone:</strong> Leave blank - validates phone format
                                </div>
                                <div className="bg-white p-2 rounded border border-gray-200">
                                  <strong>numeric:</strong> Leave blank - checks only digits
                                </div>
                                <div className="bg-white p-2 rounded border border-gray-200">
                                  <strong>boolean:</strong> Leave blank - validates true/false
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  )}
                </div>
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Custom Error Message
                </label>
                <textarea
                  name="error_message"
                  value={formData.error_message}
                  onChange={handleInputChange}
                  rows={2}
                  placeholder="Leave blank for default. Supports {field}, {value}, {limit}"
                  className="input"
                />
              </div>

              <div>
                <label className="block text-sm font-medium text-gray-700 mb-1">
                  Order
                </label>
                <input
                  type="number"
                  name="order"
                  value={formData.order}
                  onChange={handleInputChange}
                  className="input"
                />
                <p className="text-xs text-gray-500 mt-1">
                  Lower numbers run first
                </p>
              </div>

              <div className="flex items-center">
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

export default FieldRules;
