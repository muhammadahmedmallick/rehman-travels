"""
Validation admin — lets you create/edit schemas and rules directly in Django admin
without any code changes or deploys.
"""
from django.contrib import admin
from apps.validation.models import FieldRule, ValidationSchema


class FieldRuleInline(admin.TabularInline):
    model = FieldRule
    extra = 1
    fields = ['field_name', 'rule_type', 'rule_value', 'error_code', 'error_message', 'order', 'is_active']
    ordering = ['field_name', 'order']
    show_change_link = True


@admin.register(ValidationSchema)
class ValidationSchemaAdmin(admin.ModelAdmin):
    list_display  = ['schema_type', 'description', 'fail_fast', 'is_active', 'rule_count', 'updated_at']
    list_filter   = ['is_active', 'fail_fast']
    search_fields = ['schema_type', 'description']
    readonly_fields = ['created_at', 'updated_at']
    inlines = [FieldRuleInline]

    @admin.display(description='Rules')
    def rule_count(self, obj):
        return obj.rules.filter(is_active=True).count()


@admin.register(FieldRule)
class FieldRuleAdmin(admin.ModelAdmin):
    list_display  = ['schema', 'field_name', 'rule_type', 'rule_value', 'error_code', 'order', 'is_active']
    list_filter   = ['schema', 'rule_type', 'error_code', 'is_active']
    search_fields = ['field_name', 'rule_value', 'error_message']
    ordering      = ['schema__schema_type', 'field_name', 'order']
    list_select_related = ['schema']
