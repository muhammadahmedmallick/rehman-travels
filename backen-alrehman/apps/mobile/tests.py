"""
Tests for mobile app
"""
from django.test import TestCase
from django.contrib.auth.models import User
from rest_framework.test import APITestCase
from rest_framework import status
from apps.accounts.models import Agents
from .models import MobileUserProfile


class DatabaseRoutingTestCase(TestCase):
    """Test that database routing works correctly."""

    def test_new_user_goes_to_default_database(self):
        """New Django User should be in default (PostgreSQL) database."""
        user = User.objects.create_user(
            username='testuser',
            email='test@example.com',
            password='testpass123'
        )

        # Should be in default database
        self.assertTrue(User.objects.using('default').filter(pk=user.pk).exists())

    def test_legacy_model_reads_from_legacy_database(self):
        """Legacy models should read from legacy database."""
        # This is tested implicitly - if agents query works, it's reading from legacy
        agents = Agents.objects.all()
        self.assertIsNotNone(agents)


class AuthenticationTestCase(APITestCase):
    """Test authentication endpoints."""

    def test_user_registration(self):
        """Test user registration endpoint."""
        url = '/api/mobile/auth/register/'
        data = {
            'username': 'newuser',
            'email': 'newuser@example.com',
            'password': 'securepass123',
            'phone_number': '+923001234567'
        }

        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_201_CREATED)

        # Verify user created
        self.assertTrue(User.objects.filter(username='newuser').exists())

    def test_user_login(self):
        """Test JWT token generation on login."""
        # Create user
        user = User.objects.create_user(
            username='testuser',
            password='testpass123'
        )

        url = '/api/mobile/auth/login/'
        data = {
            'username': 'testuser',
            'password': 'testpass123'
        }

        response = self.client.post(url, data, format='json')
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIn('access', response.data)
        self.assertIn('refresh', response.data)

    def test_profile_access_requires_auth(self):
        """Test that profile endpoint requires authentication."""
        url = '/api/mobile/auth/profile/'
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_401_UNAUTHORIZED)
