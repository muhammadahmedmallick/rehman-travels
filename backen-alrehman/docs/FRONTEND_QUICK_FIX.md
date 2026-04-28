# Frontend Quick Fix - "e.slice is not a function" Error

## The Problem

```
Uncaught TypeError: e.slice is not a function
```

This error occurs when you try to use array methods on **string fields** instead of **array fields**.

---

## Quick Fix Checklist

### ✅ Replace These Field Names:

| ❌ WRONG (String) | ✅ CORRECT (Array) | Where Used |
|-------------------|-------------------|------------|
| `package.tags` | `package.tags_list` | Packages API |
| `variant.requirements` | `variant.requirements_list` | Visa Variants API |

---

## Common Code Fixes

### Fix 1: Package Tags

**❌ BEFORE (Broken):**
```javascript
// This will error: "e.slice is not a function"
const displayTags = package.tags.slice(0, 3);
const tagElements = package.tags.map(tag => `<span>${tag}</span>`);
const hasTag = package.tags.includes('economy');
```

**✅ AFTER (Fixed):**
```javascript
// Use tags_list instead
const displayTags = package.tags_list.slice(0, 3);
const tagElements = package.tags_list.map(tag => `<span>${tag}</span>`);
const hasTag = package.tags_list.includes('economy');
```

---

### Fix 2: Visa Requirements

**❌ BEFORE (Broken):**
```javascript
// This will error: "e.slice is not a function"
const topRequirements = variant.requirements.slice(0, 5);
const requirementsList = variant.requirements.map(req => `<li>${req}</li>`);
const hasRequirement = variant.requirements.filter(r => r.includes('Passport'));
```

**✅ AFTER (Fixed):**
```javascript
// Use requirements_list instead
const topRequirements = variant.requirements_list.slice(0, 5);
const requirementsList = variant.requirements_list.map(req => `<li>${req}</li>`);
const hasRequirement = variant.requirements_list.filter(r => r.includes('Passport'));
```

---

### Fix 3: React/Vue Components

**React - ❌ BEFORE:**
```jsx
function PackageCard({ package }) {
  return (
    <div>
      {package.tags.slice(0, 3).map(tag => (
        <Badge key={tag}>{tag}</Badge>
      ))}
    </div>
  );
}
```

**React - ✅ AFTER:**
```jsx
function PackageCard({ package }) {
  return (
    <div>
      {package.tags_list.slice(0, 3).map(tag => (
        <Badge key={tag}>{tag}</Badge>
      ))}
    </div>
  );
}
```

**Vue - ❌ BEFORE:**
```vue
<template>
  <div>
    <span v-for="tag in package.tags.slice(0, 3)" :key="tag">
      {{ tag }}
    </span>
  </div>
</template>
```

**Vue - ✅ AFTER:**
```vue
<template>
  <div>
    <span v-for="tag in package.tags_list.slice(0, 3)" :key="tag">
      {{ tag }}
    </span>
  </div>
</template>
```

---

## Global Search & Replace

### Step 1: Find All Occurrences

Search your codebase for these patterns:

```
package.tags.slice
package.tags.map
package.tags.filter
package.tags.forEach
package.tags.includes
package.tags.find
package.tags.some
package.tags.every
package.tags[0]
package.tags.length

variant.requirements.slice
variant.requirements.map
variant.requirements.filter
variant.requirements.forEach
variant.requirements.includes
variant.requirements.find
variant.requirements.some
variant.requirements.every
variant.requirements[0]
variant.requirements.length
```

### Step 2: Replace With:

```
package.tags_list.slice
package.tags_list.map
package.tags_list.filter
package.tags_list.forEach
package.tags_list.includes
package.tags_list.find
package.tags_list.some
package.tags_list.every
package.tags_list[0]
package.tags_list.length

variant.requirements_list.slice
variant.requirements_list.map
variant.requirements_list.filter
variant.requirements_list.forEach
variant.requirements_list.includes
variant.requirements_list.find
variant.requirements_list.some
variant.requirements_list.every
variant.requirements_list[0]
variant.requirements_list.length
```

---

## VS Code Regex Find & Replace

### For Packages:

**Find:**
```regex
package\.tags\.(slice|map|filter|forEach|includes|find|some|every|\[)
```

**Replace:**
```
package.tags_list.$1
```

### For Variants:

**Find:**
```regex
variant\.requirements\.(slice|map|filter|forEach|includes|find|some|every|\[)
```

**Replace:**
```
variant.requirements_list.$1
```

---

## Additional Checks

### Check 1: Verify Array Type

Add this check during development:

```javascript
console.log('Is array?', Array.isArray(package.tags_list));  // Should log: true
console.log('Is array?', Array.isArray(package.tags));       // Should log: false
```

### Check 2: Validate API Response

Add this to your API fetch:

```javascript
const response = await fetch('/api/mobile/packages/');
const data = await response.json();

// Verify structure
console.assert(Array.isArray(data.results), 'Results should be array');
console.assert(Array.isArray(data.results[0].tags_list), 'tags_list should be array');
console.assert(typeof data.results[0].tags === 'string', 'tags should be string');
```

---

## When to Use Each Field

### Use `tags` (String) When:
- ✅ Displaying the raw comma-separated list
- ✅ Passing to backend for update
- ✅ Showing in text input field

```javascript
// Display: "economy, budget, group"
<p>Tags: {package.tags}</p>

// Text input
<input type="text" value={package.tags} />
```

### Use `tags_list` (Array) When:
- ✅ Iterating/looping
- ✅ Slicing/filtering
- ✅ Counting items
- ✅ Checking if contains item
- ✅ Rendering multiple elements

```javascript
// Count
const tagCount = package.tags_list.length;

// Check
const hasEconomy = package.tags_list.includes('economy');

// Render badges
package.tags_list.map(tag => <Badge>{tag}</Badge>)

// Display first 3
package.tags_list.slice(0, 3)
```

---

## Testing Your Fix

After making changes, test these scenarios:

### Test 1: Package List
```javascript
const response = await fetch('http://3.222.113.143:8000/api/mobile/packages/');
const data = await response.json();
const firstPackage = data.results[0];

// These should NOT error:
console.log(firstPackage.tags_list.slice(0, 3));
console.log(firstPackage.tags_list.map(t => t.toUpperCase()));
console.log(firstPackage.tags_list.includes('economy'));
```

### Test 2: Visa Variants
```javascript
const response = await fetch('http://3.222.113.143:8000/api/mobile/visas/variants/');
const data = await response.json();
const firstVariant = data.results[0];

// These should NOT error:
console.log(firstVariant.requirements_list.slice(0, 5));
console.log(firstVariant.requirements_list.map(r => `• ${r}`));
console.log(firstVariant.rules.length);
```

### Test 3: Empty Arrays
```javascript
// Should handle empty arrays gracefully:
const emptyTags = package.tags_list || [];
const displayTags = emptyTags.slice(0, 3);  // Works even if empty
```

---

## Still Getting Errors?

If you still see `.slice is not a function` after fixing:

1. **Clear browser cache** and reload
2. **Check variable names** - make sure you didn't miss any
3. **Verify API response** in Network tab - confirm `tags_list` is an array
4. **Check destructuring** - if you're using destructuring, update it:

```javascript
// ❌ BEFORE
const { tags } = package;
const firstThree = tags.slice(0, 3);  // ERROR

// ✅ AFTER
const { tags_list } = package;
const firstThree = tags_list.slice(0, 3);  // WORKS
```

5. **Check spreading** - if using spread operator:

```javascript
// ❌ BEFORE
const allTags = [...package.tags];  // ERROR

// ✅ AFTER
const allTags = [...package.tags_list];  // WORKS
```

---

## Summary

**The golden rule:**
- Use `*_list` fields (like `tags_list`, `requirements_list`) for **array operations**
- Use base fields (like `tags`, `requirements`) for **display only**

**Quick mnemonic:**
"If you need to `.slice()`, `.map()`, or iterate - use the `_list` version!"
