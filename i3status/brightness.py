#! /usr/bin/env python3

import os.path
import glob
import json

backlight_dir = glob.glob("/sys/class/backlight/*")[0]


def get_from_file(name):
    with open(os.path.join(backlight_dir, name), "r") as f:
        return int(f.read())


max_brightness = get_from_file("max_brightness")


class Py3status:
    cache_timeout = 0

    def brightness(self):
        current = get_from_file("brightness")

        return {
            "full_text": "BRT " + str(int(100 * (current / max_brightness))) + "%",
        }


if __name__ == "__main__":
    s = Py3status()
    print(json.dumps(s.brightness(), indent=4))
