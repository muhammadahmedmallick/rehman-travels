"""
Base model classes for legacy and new models.
"""
from django.db import models


class LegacyModel(models.Model):
    """
    Base class for models mapped from Laravel database.

    Characteristics:
    - managed = False (Django doesn't control schema)
    - Read-only access via database router
    - Must specify db_table in Meta
    """

    class Meta:
        abstract = True
        managed = False  # Django doesn't create/modify tables


class NewModel(models.Model):
    """
    Base class for new Django models.

    Characteristics:
    - managed = True (Django controls schema)
    - Full read/write access
    - Stored in PostgreSQL
    """

    class Meta:
        abstract = True
        managed = True  # Django manages migrations
