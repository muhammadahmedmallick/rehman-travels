"""
Generate Django REST Framework ViewSets for all models
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

def generate_viewsets(app_name, models):
    """Generate views.py for an app"""
    if not models:
        return

    file_path = f'apps/{app_name}/views.py'

    content = []
    content.append('"""\n')
    content.append(f'{app_name.capitalize()} API views\n')
    content.append('"""\n')
    content.append('from rest_framework import viewsets, filters\n')
    content.append('from rest_framework.permissions import IsAuthenticated\n')
    content.append('from django_filters.rest_framework import DjangoFilterBackend\n')
    content.append(f'from apps.{app_name}.models import (\n')

    for i, model in enumerate(models):
        if i < len(models) - 1:
            content.append(f'    {model},\n')
        else:
            content.append(f'    {model}\n')
    content.append(')\n')

    content.append(f'from apps.{app_name}.serializers import (\n')
    for i, model in enumerate(models):
        if i < len(models) - 1:
            content.append(f'    {model}Serializer,\n')
        else:
            content.append(f'    {model}Serializer\n')
    content.append(')\n\n\n')

    # Generate ViewSet classes
    for model in models:
        content.append(f'class {model}ViewSet(viewsets.ModelViewSet):\n')
        content.append('    """\n')
        content.append(f'    ViewSet for {model} model\n')
        content.append('    Provides CRUD operations\n')
        content.append('    """\n')
        content.append(f'    queryset = {model}.objects.all()\n')
        content.append(f'    serializer_class = {model}Serializer\n')
        content.append('    # permission_classes = [IsAuthenticated]  # Uncomment to require authentication\n')
        content.append('    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]\n')

        # Add common filterset_fields
        content.append('    filterset_fields = [\'id\']\n')

        # Add search_fields for models with common text fields
        search_fields = []
        if 'name' in model.lower() or model in ['Agents', 'Users', 'Customers']:
            search_fields = ['email', 'username'] if model in ['Agents', 'Users'] else ['name', 'email']
        elif 'title' in model.lower():
            search_fields = ['title']

        if search_fields:
            content.append(f'    search_fields = {search_fields}\n')

        # Add ordering
        content.append('    ordering_fields = [\'id\', \'created_at\']\n')
        content.append('    ordering = [\'-id\']\n')
        content.append('\n\n')

    with open(file_path, 'w') as f:
        f.writelines(content)

    print(f"  ✓ Generated {file_path} with {len(models)} ViewSets")

def main():
    print("Generating ViewSets...\n")

    total = 0
    for app_name in APPS:
        print(f"Processing {app_name} app...")
        models = get_models_from_file(app_name)
        if models:
            generate_viewsets(app_name, models)
            total += len(models)
        else:
            print(f"  - No models found")

    print(f"\n✅ Total {total} ViewSets generated!")

if __name__ == '__main__':
    main()
