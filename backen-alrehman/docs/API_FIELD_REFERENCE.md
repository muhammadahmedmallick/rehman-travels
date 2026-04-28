# Mobile API Field Reference Guide

## Common Frontend Errors

### Error: `Uncaught TypeError: e.slice is not a function`

**Cause**: Trying to use array methods (`.slice()`, `.map()`, `.filter()`, etc.) on string fields instead of array fields.

**Solution**: Always use the `_list` suffix fields when you need arrays.

---

## Field Naming Convention

The API provides **two versions** of certain fields:

| Field Type | Example | Data Type | Use Case |
|------------|---------|-----------|----------|
| Base field | `tags` | String | Display, storage, backend processing |
| List field | `tags_list` | Array | Frontend manipulation, iteration, slicing |

---

## Package API Fields

### GET `/api/mobile/packages/`

#### String vs Array Fields:

```json
{
  "id": 33,
  "title": "Economy Umrah Packages",
  "slug": "economy-umrah-packages",

  // ❌ Don't use array methods on these:
  "tags": "economy,budget,group,affordable",           // STRING (comma-separated)

  // ✅ Use array methods on these:
  "tags_list": ["economy","budget","group","affordable"], // ARRAY

  // Price fields
  "starting_from": "300000.00",                        // STRING (decimal)
  "formatted_starting_from": "PKR 300,000",           // STRING (formatted)
  "price": "320000.00",                               // STRING (decimal)
  "formatted_price": "PKR 320,000",                   // STRING (formatted)
  "currency": "PKR",                                   // STRING

  // Image fields - can be null
  "thumbnail": null,                                   // STRING or null
  "thumbnail_url": null,                              // STRING or null
  "banner": null,                                     // STRING or null
  "banner_url": null,                                 // STRING or null

  // Other fields
  "video_url": "https://youtube.com/watch?v=...",     // STRING
  "package_type": "umrah",                            // STRING (umrah, tour, hotel)
  "location": "Makkah, Medinah",                      // STRING
  "description": "Long text...",                      // STRING
  "contact_no": "03345169763",                        // STRING
  "whatsapp_no": "03345169763",                       // STRING
  "informational_message": "",                        // STRING

  // Booleans
  "is_active": true,                                  // BOOLEAN
  "is_featured": false,                               // BOOLEAN

  // Numbers
  "display_order": 0,                                 // INTEGER

  // Dates
  "created_at": "2026-04-21T16:40:45.197162+05:00",  // ISO 8601 string
  "updated_at": "2026-04-22T22:01:24.355739+05:00"   // ISO 8601 string
}
```

#### Frontend Usage Examples:

```javascript
// ✅ CORRECT - Using array fields
const package = response.data.results[0];

// Display first 3 tags
const displayTags = package.tags_list.slice(0, 3);

// Check if has specific tag
const hasEconomyTag = package.tags_list.includes('economy');

// Map tags to badges
const tagBadges = package.tags_list.map(tag =>
  `<span class="badge">${tag}</span>`
);

// ❌ WRONG - Don't do this
const tags = package.tags.slice(0, 3);  // ERROR: string.slice() doesn't work like this!
```

---

## Visa Variant API Fields

### GET `/api/mobile/visas/variants/`

#### String vs Array Fields:

```json
{
  "id": 172,
  "title": "30 Days",
  "slug": "dubai-30-days",
  "subtitle": "UAE Tourist Visa",

  // ❌ Don't use array methods on these:
  "requirements": "UAE Immigration Fees,Visa Service Charges,All Taxes,...", // STRING

  // ✅ Use array methods on these:
  "requirements_list": [                                                     // ARRAY
    "UAE Immigration Fees",
    "Visa Service Charges",
    "All Taxes",
    "Tourist Visa",
    "30 Days Duration of stay in UAE",
    "60 Days Validity (Travel Time )"
  ],
  "rules": [                                                                // ARRAY
    {
      "id": 68,
      "title": "UAE Immigration Fees",
      "description": "UAE Immigration Fees",
      "rule_type": "general",
      "icon": "",
      "icon_class": "fas fa-check-circle",
      "is_mandatory": true,
      "display_order": 0
    }
  ],

  // Counts
  "rules_count": 6,                                                        // INTEGER

  // Price fields
  "price": "26000.00",                                                     // STRING (decimal)
  "currency": "PKR",                                                       // STRING
  "formatted_price": "PKR 26,000",                                        // STRING (formatted)

  // String fields that can be empty
  "validity": "",                                                          // STRING (can be empty)
  "duration": "",                                                          // STRING (can be empty)
  "num_entries": "",                                                       // STRING (can be empty)
  "visa_category": "",                                                     // STRING (can be empty)

  // Images - can be null
  "thumbnail": null,                                                       // STRING or null
  "thumbnail_url": null,                                                  // STRING or null
  "banner": null,                                                         // STRING or null
  "banner_url": null,                                                     // STRING or null

  // Booleans
  "is_active": true,                                                      // BOOLEAN
  "is_featured": false,                                                   // BOOLEAN

  // Numbers
  "display_order": 0                                                      // INTEGER
}
```

#### Frontend Usage Examples:

```javascript
// ✅ CORRECT - Using array fields
const variant = response.data.results[0];

// Display first 5 requirements
const topRequirements = variant.requirements_list.slice(0, 5);

// Count mandatory rules
const mandatoryRules = variant.rules.filter(rule => rule.is_mandatory).length;

// Map requirements to list items
const requirementsList = variant.requirements_list.map(req =>
  `<li>${req}</li>`
).join('');

// Check if requirements exist
if (variant.requirements_list.length > 0) {
  // Show requirements section
}

// ❌ WRONG - Don't do this
const reqs = variant.requirements.slice(0, 5);  // ERROR: Won't work!
```

---

## Visa Type API Fields

### GET `/api/mobile/visas/types/`

```json
{
  "id": 308,
  "title": "Dubai Visit Visa",
  "slug": "visa-dubai",
  "subtitle": "",                                      // STRING (can be empty)
  "country_code": "",                                  // STRING (can be empty)
  "processing_time": "",                               // STRING (can be empty)

  // Images - can be null
  "thumbnail": null,                                   // STRING or null
  "thumbnail_url": null,                              // STRING or null
  "banner": null,                                     // STRING or null
  "banner_url": null,                                 // STRING or null

  // Counts and ranges
  "active_variants_count": 4,                         // INTEGER
  "variant_price_range": {                            // OBJECT or null
    "min": 75.0,                                      // NUMBER
    "max": 44000.0,                                   // NUMBER
    "currency": "PKR"                                 // STRING
  },
  // OR
  "variant_price_range": null,                        // null if no variants

  // Nested arrays
  "variants": [                                       // ARRAY (can be empty)
    {/* variant object */}
  ],

  // Booleans
  "is_active": true,                                  // BOOLEAN

  // Numbers
  "display_order": 2                                  // INTEGER
}
```

#### Frontend Usage Examples:

```javascript
// ✅ CORRECT - Handle null values
const visaType = response.data.results[0];

// Check if has variants
if (visaType.variants.length > 0) {
  const firstVariant = visaType.variants[0];
}

// Display price range (handle null)
if (visaType.variant_price_range) {
  const priceText = `${visaType.variant_price_range.currency} ${visaType.variant_price_range.min} - ${visaType.variant_price_range.max}`;
} else {
  const priceText = 'Price not available';
}

// Get first 3 variants
const displayVariants = visaType.variants.slice(0, 3);

// ❌ WRONG - Not checking for null
const minPrice = visaType.variant_price_range.min;  // ERROR if null!
```

---

## Pagination Response Structure

All list endpoints return paginated responses:

```json
{
  "count": 13,          // INTEGER - Total number of items
  "next": null,         // STRING or null - URL to next page
  "previous": null,     // STRING or null - URL to previous page
  "results": []         // ARRAY - Array of items
}
```

#### Frontend Usage:

```javascript
// ✅ CORRECT - Access results array
const response = await fetch('/api/mobile/packages/');
const data = await response.json();

const packages = data.results;  // ARRAY
const totalCount = data.count;  // INTEGER
const hasNextPage = data.next !== null;  // BOOLEAN

// Iterate through results
packages.forEach(pkg => {
  console.log(pkg.title);
});
```

---

## Common Patterns

### 1. Handling Empty Strings vs Null

Some fields can be **empty strings** `""` or **null**:

```javascript
// ✅ CORRECT - Check for both
if (variant.validity && variant.validity.trim()) {
  // Has validity
}

// OR use optional chaining
const validity = variant.validity?.trim() || 'Not specified';
```

### 2. Handling Images

Image fields can be `null`:

```javascript
// ✅ CORRECT - Provide fallback
const thumbnail = variant.thumbnail_url || '/images/placeholder.jpg';

// OR conditional rendering
{variant.thumbnail_url && <img src={variant.thumbnail_url} />}
```

### 3. Formatting Prices

Use the pre-formatted fields:

```javascript
// ✅ CORRECT - Use formatted version
const displayPrice = package.formatted_price;  // "PKR 320,000"

// ❌ WRONG - Don't format yourself
const displayPrice = `${package.currency} ${Number(package.price).toLocaleString()}`;
```

### 4. Working with Arrays

Always use `_list` fields for array operations:

```javascript
// ✅ CORRECT
const tags = package.tags_list;
const requirements = variant.requirements_list;
const rules = variant.rules;

// Array operations
tags.slice(0, 3)
tags.map(tag => tag.toUpperCase())
tags.filter(tag => tag.includes('economy'))
tags.includes('budget')

// ❌ WRONG - Using string fields
package.tags.slice()      // ERROR!
variant.requirements.map() // ERROR!
```

---

## TypeScript Definitions

If using TypeScript, here are the type definitions:

```typescript
// Package Type
interface Package {
  id: number;
  title: string;
  slug: string;
  thumbnail: string | null;
  thumbnail_url: string | null;
  banner: string | null;
  banner_url: string | null;
  video_url: string;
  package_type: 'umrah' | 'tour' | 'hotel';
  description: string;
  tags: string;                    // Comma-separated string
  tags_list: string[];             // Array of tags
  contact_no: string;
  whatsapp_no: string;
  informational_message: string;
  starting_from: string;           // Decimal string
  formatted_starting_from: string;
  price: string;                   // Decimal string
  currency: string;
  formatted_price: string;
  location: string;
  is_active: boolean;
  is_featured: boolean;
  display_order: number;
  created_at: string;              // ISO 8601 date string
  updated_at: string;              // ISO 8601 date string
}

// Visa Variant Type
interface VisaVariant {
  id: number;
  title: string;
  slug: string;
  subtitle: string;
  thumbnail: string | null;
  thumbnail_url: string | null;
  banner: string | null;
  banner_url: string | null;
  price: string;                   // Decimal string
  currency: string;
  formatted_price: string;
  validity: string;
  duration: string;
  num_entries: string;
  visa_category: string;
  requirements: string;            // Comma-separated string
  requirements_list: string[];     // Array of requirements
  is_active: boolean;
  is_featured: boolean;
  display_order: number;
  rules: VisaRule[];              // Array of rule objects
  rules_count: number;
}

// Visa Rule Type
interface VisaRule {
  id: number;
  title: string;
  description: string;
  rule_type: string;
  icon: string;
  icon_class: string;
  is_mandatory: boolean;
  display_order: number;
}

// Visa Type
interface VisaType {
  id: number;
  title: string;
  slug: string;
  subtitle: string;
  thumbnail: string | null;
  thumbnail_url: string | null;
  banner: string | null;
  banner_url: string | null;
  country_code: string;
  processing_time: string;
  active_variants_count: number;
  variant_price_range: {
    min: number;
    max: number;
    currency: string;
  } | null;
  variants: VisaVariant[];
  is_active: boolean;
  display_order: number;
}

// Paginated Response
interface PaginatedResponse<T> {
  count: number;
  next: string | null;
  previous: string | null;
  results: T[];
}
```

---

## Quick Reference Table

| Field Name | Type | Use `.slice()`? | Notes |
|------------|------|----------------|-------|
| `tags` | String | ❌ NO | Comma-separated, use for display only |
| `tags_list` | Array | ✅ YES | Use for iteration, slicing, filtering |
| `requirements` | String | ❌ NO | Comma-separated, use for display only |
| `requirements_list` | Array | ✅ YES | Use for iteration, slicing, filtering |
| `rules` | Array | ✅ YES | Array of objects |
| `variants` | Array | ✅ YES | Array of objects |
| `results` | Array | ✅ YES | Main data array in paginated responses |
| `price` | String | ❌ NO | Decimal string, don't use math operations |
| `formatted_price` | String | ❌ NO | Pre-formatted for display |
| `*_url` | String or null | ❌ NO | Always check for null before using |
| `is_active` | Boolean | ❌ NO | Use in if conditions |
| `display_order` | Number | ❌ NO | Integer for sorting |

---

## Debugging Tips

### If you get `.slice is not a function`:
1. ✅ Check you're using `tags_list` not `tags`
2. ✅ Check you're using `requirements_list` not `requirements`
3. ✅ Check you're using `results` array from paginated response
4. ✅ Console.log the field to verify it's an array: `console.log(Array.isArray(field))`

### If you get `Cannot read property 'min' of null`:
1. ✅ Check for null before accessing nested properties
2. ✅ Use optional chaining: `variant_price_range?.min`
3. ✅ Provide fallback values

### If images don't load:
1. ✅ Check field is not null before using
2. ✅ Provide placeholder images as fallback
3. ✅ Use `*_url` fields, not the original `*` fields

---

## Support

If you encounter any issues with the API response structure:

1. Check this reference guide first
2. Verify you're using the correct field names (`_list` suffix for arrays)
3. Check for null values before accessing nested properties
4. Use browser DevTools to inspect the actual API response

For API bugs or questions, contact the backend team.
