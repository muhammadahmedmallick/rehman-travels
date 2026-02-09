"""
Cms admin configurations
"""
from django.contrib import admin
from apps.cms.models import (
    CallRecordings,
    AssignCallRecordingFollowups,
    CmsCallbackQueries,
    CmsFaqs,
    ContentPages,
    ParentPages,
    FollowupUserLogs,
    Followups
)


@admin.register(CallRecordings)
class CallRecordingsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(AssignCallRecordingFollowups)
class AssignCallRecordingFollowupsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(CmsCallbackQueries)
class CmsCallbackQueriesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(CmsFaqs)
class CmsFaqsAdmin(admin.ModelAdmin):
    list_display = ['id', 'question']
    search_fields = ['question']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(ContentPages)
class ContentPagesAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['status', 'created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(ParentPages)
class ParentPagesAdmin(admin.ModelAdmin):
    list_display = ['title']
    search_fields = ['title']
    list_filter = ['status', 'created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(FollowupUserLogs)
class FollowupUserLogsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'

@admin.register(Followups)
class FollowupsAdmin(admin.ModelAdmin):
    list_display = ['id']
    list_filter = ['created_at']
    list_per_page = 25
    date_hierarchy = 'created_at'
