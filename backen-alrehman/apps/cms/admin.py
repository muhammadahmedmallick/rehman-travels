"""
Cms admin configurations
"""
from django.contrib import admin
from import_export import resources
from import_export.admin import ImportExportModelAdmin, ImportExportActionModelAdmin
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

class ContentPagesResource(resources.ModelResource):
    """Resource for ContentPages import/export"""
    class Meta:
        model = ContentPages
        import_id_fields = ['id']
        fields = (
            'id', 'parentid', 'metatitle', 'metadescription', 'canonicalurl',
            'urllink', 'packagetitle', 'bannerimage', 'cardimage', 'categories',
            'currencytype', 'price', 'sequence', 'shortdescription', 'includes',
            'excludes', 'documentsrequired', 'type', 'showonhome', 'description',
            'status', 'activeid', 'activetype', 'created_at', 'updated_at'
        )
        export_order = fields

@admin.register(ContentPages)
class ContentPagesAdmin(ImportExportActionModelAdmin):
    resource_class = ContentPagesResource
    list_display = ['id', 'packagetitle', 'parentid', 'status', 'sequence']
    list_filter = ['status', 'parentid', 'type', 'created_at']
    search_fields = ['packagetitle', 'metatitle', 'urllink']
    list_per_page = 25
    date_hierarchy = 'created_at'
    ordering = ['sequence']

    # Export formats available in actions dropdown
    formats = ['csv', 'xlsx', 'json']

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
