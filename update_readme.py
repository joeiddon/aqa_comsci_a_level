import os,urllib.parse
with open('README.md', 'w') as f:
    for s in os.listdir('notes'):
        f.write(f'[{s}](notes/{urllib.parse.quote(s)})\n')
