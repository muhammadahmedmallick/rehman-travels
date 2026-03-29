"""
Database router for dual-database setup.

Routes:
- Legacy Laravel models → 'legacy' MySQL database (read-only)
- New Django models → 'default' PostgreSQL database (read/write)
"""


class DatabaseRouter:
    """
    Router to control database operations for legacy vs new models.
    """

    # Apps containing legacy Laravel models (read-only)
    LEGACY_APPS = {
        'accounts',
        'ticketing',
        'umrah',
        'payments',
        'cms',
        'core',
    }

    # Apps containing new Django models (read/write)
    NEW_APPS = {
        'auth',  # Django built-in User model
        'contenttypes',
        'sessions',
        'admin',
        'mobile',  # New mobile-specific features
    }

    def db_for_read(self, model, **hints):
        """
        Route read operations to appropriate database.
        """
        if model._meta.app_label in self.LEGACY_APPS:
            return 'legacy'
        elif model._meta.app_label in self.NEW_APPS:
            return 'default'
        return None  # Let Django decide

    def db_for_write(self, model, **hints):
        """
        Route write operations to appropriate database.
        Prevent writes to legacy database.
        """
        if model._meta.app_label in self.LEGACY_APPS:
            # Block writes to legacy database
            return None  # Will raise error if write attempted
        elif model._meta.app_label in self.NEW_APPS:
            return 'default'
        return None

    def allow_relation(self, obj1, obj2, **hints):
        """
        Allow relations between models in the same database.
        """
        # Get database for each model
        db1 = self.db_for_read(obj1.__class__)
        db2 = self.db_for_read(obj2.__class__)

        # Allow relations within same database
        if db1 and db2:
            if db1 == db2:
                return True
            else:
                # Cross-database relations are problematic
                return False
        return None

    def allow_migrate(self, db, app_label, model_name=None, **hints):
        """
        Control which database gets migrations.
        """
        if app_label in self.LEGACY_APPS:
            # Never migrate legacy models
            return False  # Don't run migrations on legacy database
        elif app_label in self.NEW_APPS:
            # Only migrate new models to default database
            return db == 'default'
        return None
