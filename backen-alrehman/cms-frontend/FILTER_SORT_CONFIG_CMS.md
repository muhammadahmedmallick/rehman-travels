# Filter & Sort Configuration - React CMS Frontend

## Overview
This document describes the React CMS frontend implementation for managing Filter & Sort Configurations. The CMS provides a user-friendly interface to create, edit, and manage dynamic filter/sort configurations for different listing types (flights, hotels, visa, umrah packages).

## Features

### ✅ Implemented Features

1. **List View**
   - Display all filter configurations in a table format
   - Search functionality
   - Color-coded listing type badges (Flights, Hotels, etc.)
   - Version display
   - Active/Inactive status indicators
   - Last updated timestamps

2. **Create/Edit Modal**
   - Form with validation
   - JSON editor with syntax validation
   - Format JSON button for auto-formatting
   - Real-time JSON validation
   - Listing type selector (dropdown)
   - Version input
   - Description textarea
   - Active/Inactive toggle

3. **Preview Modal**
   - View formatted JSON configuration
   - Read-only display
   - Syntax-highlighted JSON

4. **CRUD Operations**
   - Create new configurations
   - Edit existing configurations
   - Delete configurations (with confirmation)
   - View configuration details

5. **Error Handling**
   - Toast notifications for success/error
   - JSON validation errors displayed inline
   - API error handling

## File Structure

```
cms-frontend/
├── src/
│   ├── pages/
│   │   └── FilterSortConfigs.jsx          # Main page component
│   ├── services/
│   │   └── api.js                         # API service (updated)
│   ├── components/
│   │   └── Layout.jsx                     # Navigation (updated)
│   └── App.jsx                            # Routes (updated)
```

## Components

### FilterSortConfigs.jsx

**Location**: `src/pages/FilterSortConfigs.jsx`

**Key Features**:
- React Hooks: `useState`, `useQuery`, `useMutation`
- TanStack Query for data fetching and caching
- Form state management
- JSON validation and formatting
- Modal management

**State Variables**:
```javascript
const [isModalOpen, setIsModalOpen] = useState(false);
const [isPreviewOpen, setIsPreviewOpen] = useState(false);
const [editingItem, setEditingItem] = useState(null);
const [previewItem, setPreviewItem] = useState(null);
const [searchTerm, setSearchTerm] = useState('');
const [jsonError, setJsonError] = useState('');
const [formData, setFormData] = useState({
  listing_name: '',
  config_data: '{}',
  version: '1.0',
  description: '',
  is_active: true,
});
```

**Key Functions**:
- `handleOpenModal()` - Opens create/edit modal
- `handleCloseModal()` - Closes modal and resets state
- `handleSubmit()` - Handles form submission
- `handleDelete()` - Deletes configuration with confirmation
- `validateJSON()` - Validates JSON syntax
- `formatJSON()` - Auto-formats JSON with proper indentation
- `handleOpenPreview()` - Opens preview modal
- `handleClosePreview()` - Closes preview modal

## API Integration

### Service Methods

**File**: `src/services/api.js`

```javascript
export const filterSortConfigAPI = {
  getAll: (params) => api.get('/core/filter-sort-configs/', { params }),
  getById: (id) => api.get(`/core/filter-sort-configs/${id}/`),
  getByListingName: (listingName) => api.get(`/core/filter-config/${listingName}/`),
  create: (data) => api.post('/core/filter-sort-configs/', data),
  update: (id, data) => api.put(`/core/filter-sort-configs/${id}/`, data),
  partialUpdate: (id, data) => api.patch(`/core/filter-sort-configs/${id}/`, data),
  delete: (id) => api.delete(`/core/filter-sort-configs/${id}/`),
};
```

### API Endpoints Used

**Base URL**: Configured in `.env` as `VITE_API_BASE_URL`

- `GET /api/core/filter-sort-configs/` - List all configurations
- `POST /api/core/filter-sort-configs/` - Create configuration
- `GET /api/core/filter-sort-configs/{id}/` - Get specific configuration
- `PUT /api/core/filter-sort-configs/{id}/` - Update configuration
- `DELETE /api/core/filter-sort-configs/{id}/` - Delete configuration

## Routing

### Route Configuration

**File**: `src/App.jsx`

```javascript
<Route
  path="/filter-sort-configs"
  element={
    <ProtectedRoute>
      <Layout>
        <FilterSortConfigs />
      </Layout>
    </ProtectedRoute>
  }
/>
```

**Access URL**: `http://your-domain/filter-sort-configs`

## Navigation

### Sidebar Menu

**File**: `src/components/Layout.jsx`

Added navigation item:
```javascript
{
  name: 'Filter & Sort Configs',
  href: '/filter-sort-configs',
  icon: Sliders
}
```

**Icon**: Sliders (from lucide-react)

## Usage Guide

### Creating a New Configuration

1. Navigate to "Filter & Sort Configs" in the sidebar
2. Click "Add Configuration" button
3. Fill in the form:
   - **Listing Type**: Select from dropdown (flights, hotels, umrah_packages, visa)
   - **Version**: Enter version number (e.g., 1.0, 2.1)
   - **Description**: Optional description of the configuration
   - **Configuration JSON**: Edit the JSON configuration
   - **Active**: Toggle to enable/disable the configuration
4. Click "Format JSON" to auto-format your JSON
5. Click "Create" to save

### Editing a Configuration

1. Click the Edit icon (pencil) on any row
2. Modify the form fields
3. Update the JSON configuration as needed
4. Click "Format JSON" if needed
5. Click "Update" to save changes

**Note**: Listing Type cannot be changed after creation (it's disabled in edit mode)

### Previewing a Configuration

1. Click the Eye icon on any row
2. View the formatted JSON in a modal
3. Click "Close" to exit preview

### Deleting a Configuration

1. Click the Delete icon (trash) on any row
2. Confirm deletion in the popup
3. Configuration will be removed

### Searching Configurations

1. Use the search box at the top
2. Type to filter by listing name, description, or version
3. Results update in real-time

## JSON Configuration Format

### Example: Flights Configuration

```json
{
  "calculation_config": {
    "factors": {
      "price": {
        "weight": 0.40,
        "formula": "RATIO_INVERSE",
        "description": "Lower price = higher score"
      },
      "duration": {
        "weight": 0.30,
        "formula": "RATIO_INVERSE",
        "description": "Shorter duration = higher score"
      },
      "stops": {
        "weight": 0.20,
        "formula": "LOOKUP",
        "lookup_table": {
          "0": 100,
          "1": 70,
          "2": 40,
          "3+": 10
        },
        "description": "Direct flights preferred"
      }
    },
    "ranking_rules": {
      "best_rank": {
        "sort_by": "best_score",
        "order": "DESC",
        "description": "Overall best value"
      },
      "cheapest_rank": {
        "sort_by": "price",
        "order": "ASC",
        "description": "Lowest price first"
      },
      "fastest_rank": {
        "sort_by": "duration_minutes",
        "order": "ASC",
        "description": "Shortest duration first"
      }
    },
    "tag_rules": [
      {
        "tag": "BEST",
        "condition": "best_rank == 1",
        "badge_color": "#28a745",
        "icon": "star"
      },
      {
        "tag": "CHEAPEST",
        "condition": "cheapest_rank == 1",
        "badge_color": "#007bff",
        "icon": "dollar"
      },
      {
        "tag": "FASTEST",
        "condition": "fastest_rank == 1",
        "badge_color": "#ffc107",
        "icon": "bolt"
      }
    ],
    "filters": {
      "stops": {
        "type": "checkbox",
        "label": "Stops",
        "options": [
          {"value": "0", "label": "Direct"},
          {"value": "1", "label": "1 Stop"},
          {"value": "2+", "label": "2+ Stops"}
        ]
      },
      "airlines": {
        "type": "multi-select",
        "label": "Airlines",
        "dynamic": true
      },
      "departure_time": {
        "type": "range",
        "label": "Departure Time",
        "ranges": [
          {
            "value": "morning",
            "label": "Morning (6AM-12PM)",
            "start": "06:00",
            "end": "12:00"
          },
          {
            "value": "afternoon",
            "label": "Afternoon (12PM-6PM)",
            "start": "12:00",
            "end": "18:00"
          },
          {
            "value": "evening",
            "label": "Evening (6PM-12AM)",
            "start": "18:00",
            "end": "23:59"
          }
        ]
      },
      "price_range": {
        "type": "slider",
        "label": "Price Range",
        "min_field": "price_min",
        "max_field": "price_max",
        "currency": "PKR"
      }
    },
    "round_to_decimals": 2
  }
}
```

## Listing Type Badges

Color coding for different listing types:

- **Flights**: Blue (`bg-blue-100 text-blue-800`)
- **Hotels**: Purple (`bg-purple-100 text-purple-800`)
- **Umrah Packages**: Green (`bg-green-100 text-green-800`)
- **Visa**: Orange (`bg-orange-100 text-orange-800`)

## Error Handling

### JSON Validation Errors

When editing JSON:
- Real-time validation as you type
- Error message displayed below the textarea
- Red border on invalid JSON
- Create/Update button disabled if JSON is invalid

### API Errors

- Success: Green toast notification
- Error: Red toast notification with error message
- Network errors handled gracefully

## Dependencies

### Required Packages

```json
{
  "@tanstack/react-query": "^5.28.0",
  "axios": "^1.6.7",
  "react-hot-toast": "^2.4.1",
  "lucide-react": "^0.356.0",
  "react-router-dom": "^6.22.3"
}
```

### Icons Used (lucide-react)

- `Plus` - Add button
- `Edit2` - Edit button
- `Trash2` - Delete button
- `Search` - Search input
- `X` - Close modals
- `CheckCircle` - Active status
- `XCircle` - Inactive status
- `Code` - Format JSON button, empty state
- `Eye` - Preview button
- `Sliders` - Navigation icon

## Styling

### Tailwind CSS Classes

The component uses Tailwind CSS utility classes:

- **Card**: `card` (custom class from index.css)
- **Button Primary**: `btn-primary` (custom class)
- **Button Secondary**: `btn-secondary` (custom class)
- **Input**: `input` (custom class)
- **Modal**: Fixed overlay with centered content
- **Table**: Responsive table with hover effects

### Custom CSS Classes

Defined in `src/index.css`:
```css
.btn-primary { /* Primary button styles */ }
.btn-secondary { /* Secondary button styles */ }
.card { /* Card container styles */ }
.input { /* Input field styles */ }
```

## Development

### Running the Development Server

```bash
cd cms-frontend
npm run dev
```

Access at: `http://localhost:5173` (default Vite port)

### Building for Production

```bash
npm run build
```

Output: `dist/` directory

### Environment Variables

Create `.env` file:
```env
VITE_API_BASE_URL=http://localhost:8000/api
```

## Testing Checklist

- [ ] Can create a new configuration
- [ ] Can edit existing configuration
- [ ] Can delete configuration
- [ ] Can preview JSON
- [ ] JSON validation works
- [ ] Format JSON button works
- [ ] Search filters results
- [ ] Listing type badges display correctly
- [ ] Active/Inactive toggle works
- [ ] Toast notifications appear
- [ ] Modal opens/closes properly
- [ ] Form resets after close
- [ ] Listing type is disabled in edit mode
- [ ] Navigation menu shows the new item

## Best Practices

### When Creating Configurations

1. **Use Descriptive Versions**: Use semantic versioning (e.g., 1.0, 1.1, 2.0)
2. **Add Descriptions**: Always add a description explaining what the config does
3. **Validate JSON**: Use the "Format JSON" button before saving
4. **Test Thoroughly**: Preview the JSON before saving
5. **Keep It Active**: Only set inactive if you're deprecating a config

### JSON Configuration Guidelines

1. **Follow Schema**: Use the documented schema structure
2. **Weights Should Sum to 1.0**: Ensure factor weights add up to approximately 1.0
3. **Use Meaningful Keys**: Use clear, descriptive keys in your JSON
4. **Test Formulas**: Ensure formula types match expected behavior
5. **Document Custom Logic**: Add descriptions for custom formulas

## Troubleshooting

### JSON Won't Save
- **Issue**: "Invalid JSON" error
- **Solution**: Click "Format JSON" or manually validate JSON syntax

### Can't Edit Listing Type
- **Issue**: Listing type dropdown is disabled
- **Solution**: This is by design - listing type cannot be changed after creation. Create a new config instead.

### Configuration Not Appearing
- **Issue**: Created config doesn't show in list
- **Solution**: Check if it's set to inactive, or refresh the page

### Search Not Working
- **Issue**: Search doesn't filter results
- **Solution**: Backend search is working - check API connection

## Future Enhancements

Potential improvements for future versions:

1. **JSON Schema Validation**: Add JSON schema validation for config_data
2. **Template Library**: Provide pre-built templates for common configurations
3. **Versioning**: Track version history of configurations
4. **Duplicate**: Add ability to duplicate existing configurations
5. **Import/Export**: Import/export configurations as JSON files
6. **Validation Preview**: Show how filters will appear on frontend
7. **Bulk Operations**: Enable bulk activate/deactivate
8. **Audit Log**: Track who created/modified configurations

## Related Documentation

- Backend Implementation: `/backen-alrehman/FILTER_SORT_CONFIG_IMPLEMENTATION.md`
- API Documentation: Django Admin or `/api/docs/`
- Frontend Architecture: `START_HERE.md`

## Support

For issues or questions:
- Check browser console for errors
- Verify API endpoint is accessible
- Check authentication token is valid
- Review Django backend logs
- Test API endpoints using curl/Postman
