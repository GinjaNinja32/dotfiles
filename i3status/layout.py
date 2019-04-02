#! /usr/bin/env python3

import json
import subprocess


def ori(o):
    if o == "splith":
        return "H"
    elif o == "splitv":
        return "V"
    elif o == "tabbed":
        return "T"
    elif o == "stacked":
        return "S"
    else:
        return o


def f(data):
    name = (data.get("window_properties", {}).get("instance")
            or data["name"]
            or ori(data["layout"]))

    if data["nodes"] or data["floating_nodes"]:
        d = {"name": name}
        d["nodes"] = [
            f(n)
            for n in data["nodes"]
        ]
        d["float"] = [
            f(n["nodes"][0])
            for n in data["floating_nodes"]
        ]
        d["focus"] = data["focused"]
        d["subfocus"] = any(n["focus"] or n.get("subfocus", False)
                            for n in d.get("nodes", []) + d.get("float", []))
        return d
    return {
        "name": name,
        "focus": data["focused"],
        "subfocus": False,
    }


def tostr(data):
    s = data["name"]
    if data.get("nodes"):
        s = s + "[" + " ".join(tostr(n) for n in data["nodes"]) + "]"
    if data.get("float"):
        s = s + "[F " + " ".join(tostr(n) for n in data["float"]) + "]"
    return s


def cmd(cmd):
    cmd = subprocess.Popen(cmd, stdout=subprocess.PIPE)
    return cmd.stdout.read()


class Py3status:
    cache_timeout = 0

    def container_stats(self):
        data = json.loads(cmd(["i3-msg", "-t", "get_tree"]))
        ndata = f(data)

        focus = ndata
        while not focus["focus"]:
            focus = [n for n in focus["nodes"]+focus["float"]
                     if n["focus"] or n["subfocus"]][0]

        return {
            "full_text": tostr(focus),
        }


if __name__ == "__main__":
    s = Py3status()
    print(json.dumps(s.container_stats(), indent=4))
