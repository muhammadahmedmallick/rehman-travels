"""
Fix all ForeignKey references to use string format
"""
import os
import re

APPS = ['core', 'accounts', 'ticketing', 'umrah', 'payments', 'cms']

# Map of model names to their app
MODEL_TO_APP = {
    # accounts
    'Agents': 'accounts',
    'Users': 'accounts',
    'Permissions': 'accounts',
    'PermissionAssigns': 'accounts',
    'PermissionTypes': 'accounts',
    # core
    'Customers': 'core',
    'Branches': 'core',
    # cms
    'ContentPages': 'cms',
    # umrah
    'UmrahBookingCustomers': 'umrah',
}

def fix_foreign_keys_in_file(app_name):
    """Fix ForeignKey references in a model file"""
    file_path = f'apps/{app_name}/models.py'

    if not os.path.exists(file_path):
        return

    with open(file_path, 'r') as f:
        content = f.read()

    # Find all ForeignKey references with model class (not string)
    pattern = r'models\.ForeignKey\(([A-Z]\w+),'
    matches = re.findall(pattern, content)

    fixed_count = 0
    for model_name in set(matches):
        # Skip if already a string
        if model_name in ['DO_NOTHING', 'CASCADE', 'SET_NULL', 'PROTECT']:
            continue

        # Determine if it's same app or cross-app
        if model_name in MODEL_TO_APP:
            target_app = MODEL_TO_APP[model_name]

            if target_app == app_name:
                # Same app - use simple string
                old_ref = f'models.ForeignKey({model_name},'
                new_ref = f"models.ForeignKey('{model_name}',"
            else:
                # Cross-app - use full path
                old_ref = f'models.ForeignKey({model_name},'
                new_ref = f"models.ForeignKey('{target_app}.{model_name}',"

            if old_ref in content:
                content = content.replace(old_ref, new_ref)
                fixed_count += 1
                print(f"    Fixed {model_name} -> {new_ref.split('(')[1].split(',')[0]}")

    if fixed_count > 0:
        with open(file_path, 'w') as f:
            f.write(content)

    return fixed_count

def main():
    print("Fixing ForeignKey references...\n")

    total_fixed = 0
    for app_name in APPS:
        print(f"Processing {app_name}/models.py...")
        fixed = fix_foreign_keys_in_file(app_name)
        if fixed:
            print(f"  ✓ Fixed {fixed} references")
            total_fixed += fixed
        else:
            print(f"  - No changes needed")

    print(f"\n✅ Total {total_fixed} ForeignKey references fixed!")

if __name__ == '__main__':
    main()
