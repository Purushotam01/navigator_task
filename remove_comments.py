import os
import re

def strip_comments(text):
    # Matches strings (both single and double quoted) or comments
    # group 1: strings
    # group 2: comments
    pattern = r'(".*?"|\'.*?\'|""".*?"""|\'\'\'.*?\'\'\')|(/\*.*?\*/|//[^\n]*)'
    regex = re.compile(pattern, re.MULTILINE | re.DOTALL)
    
    def replacer(match):
        if match.group(1) is not None:
            return match.group(1)
        else:
            return ""
            
    return regex.sub(replacer, text)

def process_directory(directory):
    for root, dirs, files in os.walk(directory):
        for file in files:
            if file.endswith('.dart'):
                filepath = os.path.join(root, file)
                with open(filepath, 'r', encoding='utf-8') as f:
                    content = f.read()
                
                new_content = strip_comments(content)
                
                # Remove lines that contain only whitespace (if they were comment lines)
                lines = new_content.split('\n')
                cleaned_lines = [line for line in lines if line.strip() != '']
                
                with open(filepath, 'w', encoding='utf-8') as f:
                    f.write('\n'.join(cleaned_lines) + '\n')

process_directory('lib')
