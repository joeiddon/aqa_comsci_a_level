import os,urllib.parse
with open('README.md', 'w') as f:
    for s in os.listdir('notes'):
        f.write(f'[{s}](https://joeiddon.github.io/aqa_comsci_a_level/notes/{urllib.parse.quote(s)})\n\n')
