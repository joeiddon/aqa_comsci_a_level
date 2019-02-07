import os,urllib.parse
with open('README.md', 'w') as f:
    l = sorted(os.listdir('notes'),key=lambda s:int(s[:next(i for i,c in enumerate(s) if not c.isnumeric())]))
    for s in l:
        f.write(f'[{s}](https://joeiddon.github.io/aqa_comsci_a_level/notes/{urllib.parse.quote(s)})\n\n')
