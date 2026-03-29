"""
Google OAuth2 Authentication Backend
"""
from google.auth.transport import requests
from google.oauth2 import id_token
from django.contrib.auth.models import User
from rest_framework import serializers
from apps.accounts.models import Users
from django.conf import settings


class GoogleOAuth2Backend:
    """
    Handle Google OAuth2 authentication for Flutter apps
    """

    @staticmethod
    def verify_google_token(token):
        """
        Verify Google ID token and return user information
        
        Args:
            token (str): Google ID token from frontend
            
        Returns:
            dict: User information or None if verification fails
        """
        try:
            idinfo = id_token.verify_oauth2_token(
                token,
                requests.Request(),
                settings.GOOGLE_OAUTH_CLIENT_ID
            )

            if idinfo['iss'] not in ['accounts.google.com', 'https://accounts.google.com']:
                return None

            return {
                'email': idinfo.get('email'),
                'username': idinfo.get('email', '').split('@')[0],
                'first_name': idinfo.get('given_name', ''),
                'last_name': idinfo.get('family_name', ''),
                'picture': idinfo.get('picture'),
                'sub': idinfo.get('sub'),  # Google user ID
            }
        except ValueError as e:
            return None
        except Exception as e:
            return None

    @staticmethod
    def get_or_create_user(google_user_data):
        """
        Get existing user or create new one from Google data
        
        Args:
            google_user_data (dict): User info from verify_google_token
            
        Returns:
            Users: User object
        """
        email = google_user_data.get('email')
        username = google_user_data.get('username')

        try:
            user = Users.objects.get(email=email)
        except Users.DoesNotExist:
            user = Users.objects.create(
                email=email,
                username=username,
                accountstatus='active',
                usertype='user',
                branchid=1,
                accountid=1,
                granttype='oauth2',
                scope='email profile',
                assignapi='yes',
                ordercreate='yes',
                orderretrieve='yes',
                ordercancel='yes',
                orderissuance='yes',
                ordervoid='yes',
                creditlimit=0,
                tmpcreditlimit=0,
                currentcreditlimit=0,
                markuptype='fixed',
                paymenttype='credit',
                typeofid='passport',
            )

        return user


class GoogleOAuth2Serializer(serializers.Serializer):
    """
    Serializer for Google OAuth2 token-based authentication
    """
    token = serializers.CharField(write_only=True, required=True)

    def validate(self, attrs):
        """Validate Google token"""
        token = attrs.get('token')

        google_user_data = GoogleOAuth2Backend.verify_google_token(token)
        if not google_user_data:
            raise serializers.ValidationError("Invalid Google token.")

        user = GoogleOAuth2Backend.get_or_create_user(google_user_data)
        attrs['user'] = user
        attrs['google_data'] = google_user_data

        return attrs
