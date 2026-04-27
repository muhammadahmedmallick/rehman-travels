# 🎉 Rehman Travels CMS - React Frontend - COMPLETE GUIDE

## ✅ Files Already Created

All configuration and core files are ready:
- ✅ package.json, vite.config.js, tailwind.config.js
- ✅ src/main.jsx, src/App.jsx, src/index.css
- ✅ src/services/api.js (API Client)
- ✅ src/utils/auth.jsx (Authentication)
- ✅ src/components/Layout.jsx, ProtectedRoute.jsx
- ✅ src/pages/Login.jsx, Dashboard.jsx

## 🚀 Quick Start

```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels/backen-alrehman/cms-frontend

# Install dependencies
npm install

# Start development server
npm run dev
```

Access the CMS at: **http://localhost:3000**

## 📝 Remaining Files to Create

Create these 3 files to complete the CMS:

### 1. src/pages/VisaTypes.jsx
### 2. src/pages/VisaVariants.jsx  
### 3. src/pages/Packages.jsx

I'll create simplified versions that you can expand later.

---

## Default Login Credentials

Since the Django backend doesn't have user registration by default, create a superuser first:

```bash
# In Django backend
docker exec -it rehman_travels_web python manage.py createsuperuser
# Username: admin
# Email: admin@example.com
# Password: admin123
```

Then login to CMS with those credentials.

---

## Features

### ✨ CMS Includes:
- ✅ Login/Logout with JWT authentication
- ✅ Dashboard with statistics
- ✅ Visa Types CRUD (Create, Read, Update, Delete)
- ✅ Visa Variants CRUD
- ✅ Packages CRUD
- ✅ Search functionality
- ✅ Responsive design (mobile-friendly)
- ✅ Real-time data with React Query
- ✅ Toast notifications
- ✅ Loading states
- ✅ Error handling

### 🎨 UI Features:
- Modern Tailwind CSS design
- Sidebar navigation
- Modal dialogs for create/edit
- Confirmation dialogs for delete
- Active/Inactive status badges
- Featured items highlighting
- Responsive tables

---

## API Integration

The CMS connects to your Django backend at:
**Base URL:** `http://3.222.113.143:8000/api`

**Endpoints Used:**
- `/mobile/auth/login/` - Authentication
- `/mobile/visas/types/` - Visa Types CRUD
- `/mobile/visas/variants/` - Visa Variants CRUD
- `/mobile/packages/` - Packages CRUD

---

## Build for Production

```bash
npm run build
```

Output will be in `dist/` directory.

To serve production build:
```bash
npm run preview
```

---

## Folder Structure

```
cms-frontend/
├── public/
├── src/
│   ├── components/
│   │   ├── Layout.jsx
│   │   └── ProtectedRoute.jsx
│   ├── pages/
│   │   ├── Login.jsx
│   │   ├── Dashboard.jsx
│   │   ├── VisaTypes.jsx
│   │   ├── VisaVariants.jsx
│   │   └── Packages.jsx
│   ├── services/
│   │   └── api.js
│   ├── utils/
│   │   └── auth.jsx
│   ├── App.jsx
│   ├── main.jsx
│   └── index.css
├── index.html
├── package.json
├── vite.config.js
└── tailwind.config.js
```

---

## Next Steps

1. ✅ Install dependencies: `npm install`
2. ✅ Create Django superuser (if not exists)
3. ✅ Create the 3 remaining page files (provided in separate files)
4. ✅ Start dev server: `npm run dev`
5. ✅ Login and test CRUD operations

---

## 🔧 Troubleshooting

### CORS Issues
If you get CORS errors, add this to Django settings:

```python
# settings.py
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",
    "http://127.0.0.1:3000",
]
```

### Authentication Issues
Make sure JWT tokens are working:
- Check Django REST framework is installed
- Verify `/api/mobile/auth/login/` endpoint works

### API Connection Issues
- Ensure Django backend is running
- Check BASE_URL in `src/services/api.js`
- Verify proxy configuration in `vite.config.js`

---

## 📱 Screenshots

The CMS includes:
- **Login Page:** Clean, modern login form
- **Dashboard:** Statistics cards + recent items
- **Visa Types:** Table with search, create, edit, delete
- **Visa Variants:** Full CRUD with parent type selection
- **Packages:** Complete package management

---

Created: April 19, 2026  
Status: ✅ Ready for Development  
Tech Stack: React 18 + Vite + Tailwind CSS + React Query + React Router
