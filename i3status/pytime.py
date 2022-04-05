#! /usr/bin/env python3

from datetime import datetime, timezone, timedelta
import json


class Py3status:
    cache_timeout = 0

    def time(self):
        now = datetime.now().astimezone()

        txt = now.strftime("%a %Y-%m-%d %H:%M:%S")

        if now.utcoffset() != timedelta(0):
            utcnow = now.astimezone(timezone.utc)
            txt += utcnow.strftime(" (%H:%M:%S UTC)")

        return {
            "full_text": txt,
        }


if __name__ == "__main__":
    s = Py3status()
    print(json.dumps(s.time(), indent=4))
