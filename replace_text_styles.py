import os

files = [
    'lib/features/splash/view/splash_screen.dart',
    'lib/features/home/view/home_map_screen.dart',
    'lib/features/auth/view/signup_screen.dart',
    'lib/features/auth/view/login_screen.dart',
]

def replace_in_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()

    # Add import
    if "import 'package:task/core/theme/app_text_styles.dart';" not in content:
        content = content.replace("import 'package:flutter/material.dart';", "import 'package:flutter/material.dart';\nimport 'package:task/core/theme/app_text_styles.dart';")

    # Specifically replace block by block based on common patterns
    
    # 1. Subtitle: TextStyle(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6), fontSize: 16)
    # Note: earlier it was withOpacity, which might still be present or changed to withValues.
    # Let's just use regex
    import re
    
    # Replace Subtitle (opacity 0.6, fontSize 16)
    content = re.sub(
        r'TextStyle\(\s*color:\s*Theme\.of\(context\)\.colorScheme\.primary\.withOpacity\(0\.6\),\s*fontSize:\s*16,?\s*\)',
        r'AppTextStyles.subtitle(context)',
        content
    )
    content = re.sub(
        r'TextStyle\(\s*color:\s*Theme\.of\(context\)\.colorScheme\.primary\.withValues\(alpha:\s*0\.6\),\s*fontSize:\s*16,?\s*\)',
        r'AppTextStyles.subtitle(context)',
        content
    )

    # Replace TextField style
    content = re.sub(
        r'TextStyle\(color:\s*Theme\.of\(context\)\.colorScheme\.primary\)',
        r'AppTextStyles.body(context)',
        content
    )

    # Replace link text
    content = re.sub(
        r'TextStyle\(\s*color:\s*Theme\.of\(context\)\.colorScheme\.secondary,\s*fontWeight:\s*FontWeight\.bold,?\s*\)',
        r'AppTextStyles.linkText(context)',
        content
    )
    
    # Replace Button Text
    content = re.sub(
        r'TextStyle\(\s*fontSize:\s*16,\s*fontWeight:\s*FontWeight\.bold,?\s*\)',
        r'AppTextStyles.buttonText(context)',
        content
    )
    content = re.sub(
        r'TextStyle\(fontWeight:\s*FontWeight\.bold,\s*fontSize:\s*15,?\)',
        r'AppTextStyles.buttonText(context).copyWith(fontSize: 15)',
        content
    )
    
    # Replace Splash text
    content = re.sub(
        r'TextStyle\(\s*color:\s*Colors\.white\.withOpacity\(0\.6\),\s*fontSize:\s*14,\s*letterSpacing:\s*0\.5,?\s*\)',
        r'AppTextStyles.splashSubtitle()',
        content
    )
    
    # Replace Home Map Panel title
    content = re.sub(
        r'TextStyle\(\s*color:\s*Theme\.of\(context\)\.colorScheme\.primary,\s*fontWeight:\s*FontWeight\.bold,\s*fontSize:\s*16,?\s*\)',
        r'AppTextStyles.headline(context).copyWith(fontSize: 16)',
        content
    )

    with open(filepath, 'w') as f:
        f.write(content)

for f in files:
    replace_in_file(f)
