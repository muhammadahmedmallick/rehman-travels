"""
Accounts admin configurations
"""
from django.contrib import admin
from apps.accounts.models import (
    Agents,
    Users,
    Permissions,
    PermissionAssigns,
    PermissionTypes
)


@admin.register(Agents)
class AgentsAdmin(admin.ModelAdmin):
    list_display = ['username', 'email', 'companyname', 'accountstatus']
    search_fields = ['username', 'email', 'companyname']
    list_filter = ['accountstatus', 'created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Users)
class UsersAdmin(admin.ModelAdmin):
    list_display = ['username', 'email', 'designation', 'accountstatus']
    search_fields = ['username', 'email', 'designation']
    list_filter = ['accountstatus', 'created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Permissions)
class PermissionsAdmin(admin.ModelAdmin):
    list_display = ['title', 'moduletype']
    search_fields = ['title', 'moduletype']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(PermissionAssigns)
class PermissionAssignsAdmin(admin.ModelAdmin):
    list_display = ['agentid', 'userid', 'moduletype']
    search_fields = ['agentid', 'userid', 'moduletype']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(PermissionTypes)
class PermissionTypesAdmin(admin.ModelAdmin):
    list_display = ['title', 'moduletype']
    search_fields = ['title', 'moduletype']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'
