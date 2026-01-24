"""
Generate Django REST Framework serializers for all models
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

def generate_serializers(app_name, models):
    """Generate serializers.py for an app"""
    if not models:
        return

    file_path = f'apps/{app_name}/serializers.py'

    content = []
    content.append('"""\n')
    content.append(f'{app_name.capitalize()} serializers\n')
    content.append('"""\n')
    content.append('from rest_framework import serializers\n')
    content.append(f'from apps.{app_name}.models import (\n')

    for i, model in enumerate(models):
        if i < len(models) - 1:
            content.append(f'    {model},\n')
        else:
            content.append(f'    {model}\n')
    content.append(')\n\n\n')

    # Generate serializer classes
    for model in models:
        content.append(f'class {model}Serializer(serializers.ModelSerializer):\n')
        content.append('    """\n')
        content.append(f'    Serializer for {model} model\n')
        content.append('    """\n')
        content.append('    class Meta:\n')
        content.append(f'        model = {model}\n')
        content.append("        fields = '__all__'\n")
        content.append('\n\n')

    with open(file_path, 'w') as f:
        f.writelines(content)

    print(f"  ✓ Generated {file_path} with {len(models)} serializers")

def main():
    print("Generating serializers...\n")

    total = 0
    for app_name in APPS:
        print(f"Processing {app_name} app...")
        models = get_models_from_file(app_name)
        if models:
            generate_serializers(app_name, models)
            total += len(models)
        else:
            print(f"  - No models found")

    print(f"\n✅ Total {total} serializers generated!")

if __name__ == '__main__':
    main()
