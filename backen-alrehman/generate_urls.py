"""
Generate URL routing for all apps
"""
import os
import re

APPS = ['core', 'accounts', 'ticketing', 'umrah', 'payments', 'cms']

def get_models_from_file(app_name):
    """Extract model names from models.py"""
    file_path = f'apps/{app_name}/models.py'

    if not os.path.exists(file_path):
        return []

    with open(file_path, 'r') as f:
        content = f.read()

    # Find all class definitions
    pattern = r'^class (\w+)\(models\.Model\):'
    matches = re.findall(pattern, content, re.MULTILINE)

    return matches

def generate_app_urls(app_name, models):
    """Generate urls.py for an app"""
    if not models:
        return

    file_path = f'apps/{app_name}/urls.py'

    content = []
    content.append('"""\n')
    content.append(f'{app_name.capitalize()} URL Configuration\n')
    content.append('"""\n')
    content.append('from django.urls import path, include\n')
    content.append('from rest_framework.routers import DefaultRouter\n')
    content.append(f'from apps.{app_name}.views import (\n')

    for i, model in enumerate(models):
        if i < len(models) - 1:
            content.append(f'    {model}ViewSet,\n')
        else:
            content.append(f'    {model}ViewSet\n')
    content.append(')\n\n')

    content.append('router = DefaultRouter()\n')

    # Register all ViewSets
    for model in models:
        # Convert CamelCase to kebab-case for URL
        url_name = re.sub(r'(?<!^)(?=[A-Z])', '-', model).lower()
        content.append(f"router.register(r'{url_name}', {model}ViewSet, basename='{url_name}')\n")

    content.append('\n')
    content.append('urlpatterns = [\n')
    content.append("    path('', include(router.urls)),\n")
    content.append(']\n')

    with open(file_path, 'w') as f:
        f.writelines(content)

    print(f"  ✓ Generated {file_path} with {len(models)} routes")

def generate_main_urls():
    """Update main urls.py to include all app URLs"""
    file_path = 'config/urls.py'

    content = []
    content.append('"""\n')
    content.append('Main URL Configuration\n')
    content.append('"""\n')
    content.append('from django.contrib import admin\n')
    content.append('from django.urls import path, include\n')
    content.append('from rest_framework_simplejwt.views import (\n')
    content.append('    TokenObtainPairView,\n')
    content.append('    TokenRefreshView,\n')
    content.append(')\n\n')

    content.append('urlpatterns = [\n')
    content.append("    # Admin\n")
    content.append("    path('admin/', admin.site.urls),\n\n")

    content.append("    # JWT Authentication\n")
    content.append("    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),\n")
    content.append("    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),\n\n")

    content.append("    # API Endpoints\n")
    for app in APPS:
        content.append(f"    path('api/{app}/', include('apps.{app}.urls')),\n")

    content.append(']\n')

    with open(file_path, 'w') as f:
        f.writelines(content)

    print(f"  ✓ Generated main {file_path}")

def main():
    print("Generating URL configurations...\n")

    total = 0
    for app_name in APPS:
        print(f"Processing {app_name} app...")
        models = get_models_from_file(app_name)
        if models:
            generate_app_urls(app_name, models)
            total += len(models)
        else:
            print(f"  - No models found")

    print("\nGenerating main URLs...")
    generate_main_urls()

    print(f"\n✅ Total {total} routes configured across {len(APPS)} apps!")

if __name__ == '__main__':
    main()
