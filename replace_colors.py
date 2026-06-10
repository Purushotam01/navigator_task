import os
import re

files_to_process = [
    'lib/features/auth/view/login_screen.dart',
    'lib/features/auth/view/signup_screen.dart',
    'lib/features/home/view/home_map_screen.dart',
    'lib/features/splash/view/splash_screen.dart',
]

replacements = {
    'AppConstants.primaryColor': 'Theme.of(context).colorScheme.primary',
    'AppConstants.accentColor': 'Theme.of(context).colorScheme.secondary',
    'AppConstants.backgroundColor': 'Theme.of(context).colorScheme.surface',
    'AppConstants.errorColor': 'Theme.of(context).colorScheme.error',
}

for filepath in files_to_process:
    with open(filepath, 'r') as f:
        content = f.read()
    
    for old, new in replacements.items():
        content = content.replace(old, new)
        
    # Remove const from some common patterns that break
    content = re.sub(r'const\s+(TextStyle\([^)]*Theme\.of)', r'\1', content)
    content = re.sub(r'const\s+(Icon\([^)]*Theme\.of)', r'\1', content)
    content = re.sub(r'const\s+(BoxDecoration\([^)]*Theme\.of)', r'\1', content)
    content = re.sub(r'const\s+(Text\([^)]*Theme\.of)', r'\1', content)

    with open(filepath, 'w') as f:
        f.write(content)

