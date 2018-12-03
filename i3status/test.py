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
    bg = entry.get('background', None)
    text = entry['full_text']

    sep = ""
    if 'separator' in entry:
        if entry['separator']:
            sep = "\x1b[90m|\x1b[0m"
        else:
            sep = " "

    c = ""

    if color is not None:
        r = int(color[1:3], 16)
        g = int(color[3:5], 16)
        b = int(color[5:7], 16)
        c += "\x1b[38;2;%d;%d;%dm" % (r, g, b)

    if bg is not None:
        r = int(bg[1:3], 16)
        g = int(bg[3:5], 16)
        b = int(bg[5:7], 16)
        c += "\x1b[48;2;%d;%d;%dm" % (r, g, b)

    print("%s%s\x1b[0m" % (c, text), end=sep)

print("")
