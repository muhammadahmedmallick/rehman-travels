# Local Development Setup Instructions

## Current Status

✅ **Installed:**
- PHP 8.2.30
- Composer 2.9.3
- MySQL 9.6.0
- Node.js v24.11.0
- All PHP dependencies (via Composer)
- All Node dependencies (via npm)

## Issue: Database Setup Required

The application requires database tables to run. The `AppServiceProvider` queries the database on boot, which prevents the app from starting without an existing database structure.

## Solutions

### Option 1: Import Production Database (Recommended)

If you have access to the production database, export it and import locally:

```bash
# Get the production database dump (run on production server)
# mysqldump -u rehmansrvne_mainusr -p rehmansrvne_maindb > database_dump.sql

# Import it locally
mysql -u rehmansrvne_mainusr -p rehmansrvne_maindb < database_dump.sql

# Then start the servers
cd /Users/muhammadahmed/Desktop/personal/rehman-travels/legacy-app/rehman-travels
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
php artisan serve &
npm run dev
```

### Option 2: Temporarily Disable Database Queries in AppServiceProvider

Edit `app/Providers/AppServiceProvider.php` to skip database queries in local environment:

```php
public function boot(): void
{
    if(config('app.env') === 'production'):
        $this->app['request']->server->set('HTTPS', true);
    endif;

    // Skip database queries if running artisan commands or in local env
    if (app()->runningInConsole() || config('app.env') === 'local') {
        Inertia::share([
            'menus'=> [],
            'currencies'=> [],
            'footer' => [],
            'getNum' => 0,
            'permissions' => function () { return null; },
        ]);
        return;
    }

    Inertia::share([
        'menus'=> ParentPage::getContents(),
        'currencies'=> Currency::whereNotIn('currencyCode',['DEF'])->orderBy('id', 'asc')->get(),
        'footer' => Branch::getBranches(),
        'getNum' => VisitorProvider::visiter(),
        'permissions' => function () {
            if(!empty(Session::get('vendorId'))):
                return PermissionAssign::loggedInUserPermission(Session::get('vendorId'),Session::get('agentId'),Session::get('userId'));
            endif;
        },
    ]);
}
```

Then update `.env`:
```env
APP_ENV=local
APP_DEBUG=true
```

### Option 3: Create Minimal Database Structure

Run migrations if they exist:

```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels/legacy-app/rehman-travels
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"

# Check migrations
ls -la database/migrations/

# Run migrations (if the AppServiceProvider issue is fixed first)
php artisan migrate
```

## Starting the Application

Once database is set up, start both servers:

### Terminal 1 - Laravel Server:
```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels/legacy-app/rehman-travels
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
php artisan serve
```

### Terminal 2 - Vite Dev Server:
```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels/legacy-app/rehman-travels
npm run dev
```

Then visit: **http://localhost:8000**

## Quick Start Script (After Database Setup)

I've created a start script at:
`/Users/muhammadahmed/Desktop/personal/rehman-travels/START_APP.sh`

Run it with:
```bash
cd /Users/muhammadahmed/Desktop/personal/rehman-travels
./START_APP.sh
```

## Database Credentials (from .env)

```
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=rehmansrvne_maindb
DB_USERNAME=rehmansrvne_mainusr
DB_PASSWORD=MS3*z8?!p}*j&*)(@#
```

The database and user have been created in your local MySQL instance.

## Notes

- **Production External API**: The flight search uses external APIs (http://exaltedrestapiandrehmantravel.local/api/) which may not be accessible locally
- **Vite Build Directory**: Assets are built to `../../public_html/build` (shared hosting structure)
- **Testing**: See `TESTING_GUIDE.md` for flight search testing procedures

## Troubleshooting

### MySQL not running:
```bash
brew services start mysql
```

### PHP not in PATH:
```bash
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
```

### Port already in use:
```bash
# Kill process on port 8000
lsof -ti:8000 | xargs kill -9

# Or use a different port
php artisan serve --port=8080
```
