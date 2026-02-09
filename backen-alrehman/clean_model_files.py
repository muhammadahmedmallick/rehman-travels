"""
Clean all model files by removing SQL debris
"""
import os
import re

APPS = ['core', 'accounts', 'ticketing', 'umrah', 'payments', 'cms']

def is_valid_python_line(line):
    """Check if a line looks like valid Python code"""
    stripped = line.strip()

    # Empty lines are fine
    if not stripped:
        return True

    # Comments are fine
    if stripped.startswith('#'):
        return True

    # SQL keywords/patterns that shouldn't be in Python code
    sql_patterns = [
        'AND referenced_column', 'AND table_schema', 'constraint_type',
        'column_name,', 'numeric_precision', 'table_collation',
        'WHEN collation_name', 'END AS', 'information_schema',
        'constraint_schema', 'column_type LIKE', 'is_unsigned',
        'column_comment', '`constraint_name`', 'referenced_table',
        'kc.table_schema', 'tc.constraint_type', 'ordinal_position',
        'c.constraint_name = kc.constraint_name AND',
        'ELSE collation_name', 'ELSE 0', 'cc.constraint_name = tc.constraint_name AND',
        'kc.constraint_name', 'tc.constraint_name'
    ]

    for pattern in sql_patterns:
        if pattern in line:
            return False

    # Lines that start with indentation but are just SQL fragments
    if stripped and not stripped.startswith(('class ', 'def ', 'import ', 'from ', '@')):
        # If it doesn't have an assignment or function call, might be SQL
        if not any(marker in line for marker in [' = models.', '(', 'return ', 'self.', '"""', "'''"]):
            # Check for SQL-like patterns
            if any(word in stripped for word in ['AND', 'ELSE', 'END', 'CASE']) and not stripped.endswith(':'):
                return False

    return True

def clean_model_file(app_name):
    """Clean a single model file"""
    file_path = f'apps/{app_name}/models.py'

    if not os.path.exists(file_path):
        print(f"  ✗ {file_path} not found")
        return

    with open(file_path, 'r') as f:
        lines = f.readlines()

    clean_lines = []
    for line in lines:
        if is_valid_python_line(line):
            clean_lines.append(line)

    # Write cleaned content
    with open(file_path, 'w') as f:
        f.writelines(clean_lines)

    removed = len(lines) - len(clean_lines)
    print(f"  ✓ {app_name}/models.py: Removed {removed} SQL lines, kept {len(clean_lines)} lines")

def main():
    print("Cleaning model files...\n")

    for app in APPS:
        clean_model_file(app)

    print("\n✅ All model files cleaned!")

if __name__ == '__main__':
    main()
