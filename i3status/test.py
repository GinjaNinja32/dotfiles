#! /usr/bin/env python3

import sys
import json

data = json.load(sys.stdin)

if 'composite' in data:
    data = data['composite']
else:
    data = [data]

for entry in data:
    color = entry.get('color', None)
    text = entry['full_text']

    sep = ""
    if 'separator' in entry:
        if entry['separator']:
            sep = "\x1b[90m|\x1b[0m"
        else:
            sep = " "

    if color is None:
        print(text, end=sep)
    else:
        r = int(color[1:3], 16)
        g = int(color[3:5], 16)
        b = int(color[5:7], 16)
        print("\x1b[38;2;%d;%d;%dm%s\x1b[0m" % (r, g, b, text), end=sep)

print("")
