"""
Cms serializers
"""
from rest_framework import serializers
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


class CallRecordingsSerializer(serializers.ModelSerializer):
    """
    Serializer for CallRecordings model
    """
    class Meta:
        model = CallRecordings
        fields = '__all__'


class AssignCallRecordingFollowupsSerializer(serializers.ModelSerializer):
    """
    Serializer for AssignCallRecordingFollowups model
    """
    class Meta:
        model = AssignCallRecordingFollowups
        fields = '__all__'


class CmsCallbackQueriesSerializer(serializers.ModelSerializer):
    """
    Serializer for CmsCallbackQueries model
    """
    class Meta:
        model = CmsCallbackQueries
        fields = '__all__'


class CmsFaqsSerializer(serializers.ModelSerializer):
    """
    Serializer for CmsFaqs model
    """
    class Meta:
        model = CmsFaqs
        fields = '__all__'


class ContentPagesSerializer(serializers.ModelSerializer):
    """
    Serializer for ContentPages model
    """
    class Meta:
        model = ContentPages
        fields = '__all__'


class ParentPagesSerializer(serializers.ModelSerializer):
    """
    Serializer for ParentPages model
    """
    class Meta:
        model = ParentPages
        fields = '__all__'


class FollowupUserLogsSerializer(serializers.ModelSerializer):
    """
    Serializer for FollowupUserLogs model
    """
    class Meta:
        model = FollowupUserLogs
        fields = '__all__'


class FollowupsSerializer(serializers.ModelSerializer):
    """
    Serializer for Followups model
    """
    class Meta:
        model = Followups
        fields = '__all__'


