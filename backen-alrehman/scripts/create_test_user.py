#!/usr/bin/env python
"""
Script to create test users for Django and Mobile API

Usage:
    # Create superuser (for Django admin)
    python scripts/create_test_user.py --superuser

    # Create regular mobile user
    python scripts/create_test_user.py --mobile

    # Create specific user
    python scripts/create_test_user.py --username ahmed --email ahmed@example.com --password click123
"""
import os
import sys
import django

# Setup Django environment
sys.path.insert(0, os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'config.settings.development')
django.setup()

from django.contrib.auth.models import User
import argparse


def create_superuser(username='admin', email='admin@example.com', password='admin123'):
    """Create a superuser for Django admin"""
    if User.objects.filter(username=username).exists():
        print(f"❌ User '{username}' already exists!")
        user = User.objects.get(username=username)
        print(f"   Email: {user.email}")
        print(f"   Is superuser: {user.is_superuser}")
        print(f"   Is staff: {user.is_staff}")
        return None

    user = User.objects.create_superuser(
        username=username,
        email=email,
        password=password
    )
    print(f"✅ Superuser created successfully!")
    print(f"   Username: {username}")
    print(f"   Email: {email}")
    print(f"   Password: {password}")
    print(f"\n🔐 Login to Django Admin at: http://localhost:8000/admin/")
    print(f"   Username: {username}")
    print(f"   Password: {password}")
    return user


def create_mobile_user(username='testuser', email='test@example.com', password='test123'):
    """Create a regular user for mobile API"""
    if User.objects.filter(username=username).exists():
        print(f"❌ User '{username}' already exists!")
        user = User.objects.get(username=username)
        print(f"   Email: {user.email}")
        print(f"   Is superuser: {user.is_superuser}")
        print(f"   Is staff: {user.is_staff}")
        return None

    user = User.objects.create_user(
        username=username,
        email=email,
        password=password,
        first_name='Test',
        last_name='User'
    )
    print(f"✅ Mobile user created successfully!")
    print(f"   Username: {username}")
    print(f"   Email: {email}")
    print(f"   Password: {password}")
    print(f"\n📱 Test login with curl:")
    print(f"""
curl -X POST http://localhost:8000/api/mobile/auth/login/ \\
  -H "Content-Type: application/json" \\
  -d '{{"username":"{username}","password":"{password}"}}'
    """)
    return user


def list_users():
    """List all users"""
    users = User.objects.all()
    print(f"\n👥 Total users: {users.count()}")
    print("\n" + "="*80)
    for user in users:
        print(f"Username: {user.username:20} | Email: {user.email:30}")
        print(f"  - Superuser: {user.is_superuser:5} | Staff: {user.is_staff:5} | Active: {user.is_active}")
        print("-"*80)


if __name__ == '__main__':
    parser = argparse.ArgumentParser(description='Create test users')
    parser.add_argument('--superuser', action='store_true', help='Create superuser for Django admin')
    parser.add_argument('--mobile', action='store_true', help='Create regular user for mobile API')
    parser.add_argument('--list', action='store_true', help='List all users')
    parser.add_argument('--username', type=str, help='Custom username')
    parser.add_argument('--email', type=str, help='Custom email')
    parser.add_argument('--password', type=str, help='Custom password')

    args = parser.parse_args()

    if args.list:
        list_users()
    elif args.superuser:
        username = args.username or 'admin'
        email = args.email or 'admin@example.com'
        password = args.password or 'admin123'
        create_superuser(username, email, password)
    elif args.mobile:
        username = args.username or 'testuser'
        email = args.email or 'test@example.com'
        password = args.password or 'test123'
        create_mobile_user(username, email, password)
    elif args.username and args.password:
        email = args.email or f"{args.username}@example.com"
        create_mobile_user(args.username, email, args.password)
    else:
        print("Usage:")
        print("  Create superuser:  python scripts/create_test_user.py --superuser")
        print("  Create mobile user: python scripts/create_test_user.py --mobile")
        print("  List users:        python scripts/create_test_user.py --list")
        print("\nCustom user:")
        print("  python scripts/create_test_user.py --username ahmed --email ahmed@example.com --password click123")
