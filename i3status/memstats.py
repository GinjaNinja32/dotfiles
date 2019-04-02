#! /usr/bin/env python3

import subprocess
import math
import json
import os.path


def fmtM(val):
    if val >= 1000:
        return "%.1fG" % (val/1000)
    if val >= 10:
        return "%dM" % val
    else:
        return "%.1fM" % val


class Py3status:
    compact = False
    cache_timeout = 5

    def _cmd(self, cmd):
        cmd = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        return cmd.stdout.readlines()

    def _color(self, bf):
        if bf > 1:
            return "#ff0000"
        red = int(255 * math.sqrt(bf))
        green = int(255 * math.sqrt(1-bf))
        return "#%0.2x%0.2x00" % (red, green)

    def memstats(self):
        memT, memU, memF, memA = 0, 0, 0, 0
        swpT, swpU = 0, 0

        for l in self._cmd(["free", "-m"]):
            arr = l.split()
            if arr[0] == b"Mem:":
                memT = int(arr[1])
                memU = int(arr[2])
                memF = int(arr[3])
                memA = int(arr[6])

            elif arr[0] == b"Swap:":
                swpT = int(arr[1])
                swpU = int(arr[2])

        cpu = {}
        cpuTotal = 0

        processStates = {
            "S": 0,
            "I": 0,
            "Z": 0,
            "R": 0,
            "D": 0,
        }

        for l in self._cmd(["ps", "aux"]):
            arr = l.split()

            if arr[0] == b"USER":
                continue

            arr[10] = arr[10].decode("utf-8").split("/")[-1]

            #if arr[10] not in mem:
            #    mem[arr[10]] = 0
            if arr[10] not in cpu:
                cpu[arr[10]] = 0

            cpu[arr[10]] += float(arr[2])
            cpuTotal += float(arr[2])
            #mem[arr[10]] += int(arr[5])

            state = arr[7][:1].decode("utf-8")

            if state not in processStates:
                processStates[state] = 0

            processStates[state] += 1

        items = []
        statesList = sorted(processStates.keys())
        for k in statesList:
            v = processStates[k]
            color = "#00ff00"
            if k not in ["S", "I"]:
                color = self._color(v/5)
            items.append({
                "full_text": "%s=%d" % (k, v),
                "separator": k == statesList[-1],
                "color": color,
                "k": k,
            })

        mem = {}
        for l in self._cmd(["bash", "-c", "cd %s && ./memstats" % os.path.dirname(os.path.realpath(__file__))]):
            arr = l.decode("utf-8").strip().split(" ", 1)

            if arr[1] not in mem:
                mem[arr[1]] = 0

            mem[arr[1]] += int(arr[0])

        if swpU > 0:
            items.append({
                "full_text": "SWP: %s/%s" % (fmtM(swpU), fmtM(swpT)),
                "color": "#00ff00",  # self._color(max(0, 10 * swpU / swpT)),
                "separator": True,
                "a": 1,
            })

        memitems = ["%s/%s F=%s A=%s" % (fmtM(memU),
                                         fmtM(memT),
                                         fmtM(memF),
                                         fmtM(memA))]
        if not self.compact:
            for v, k in reversed(sorted([(mem[a], a) for a in mem])[-3:]):
                memitems.append("%s=%s" % (k, fmtM(v / 1000)))

        items.append({
            "full_text": " ".join(memitems),
            "color": self._color(max(0, (0.5 * memT / memA) - 1)),
            "separator": True,
            "a": 2,
        })

        cpuitems = ["%.1f%%" % cpuTotal]
        if not self.compact:
            for v, k in reversed(sorted([(cpu[a], a) for a in cpu])[-3:]):
                cpuitems.append("%s=%.1f" % (k, v))

        items.append({
            "full_text": " ".join(cpuitems),
            "color": self._color(max(0, cpuTotal / 100 - 1)),
            "separator": True,
            "a": 3,
        })

        with open("/proc/loadavg", "r") as f:
            la = [float(n) for n in f.read().split(" ")[:3]]

        for i in [0, 1, 2]:
            items.append({
                "full_text": "%.2f" % la[i],
                "color": self._color(max(0, (la[i]-4) / 4)),
                "separator": i == 2,
                "a": 4+i,
            })

        return {"composite": items}


if __name__ == "__main__":
    s = Py3status()
    print(json.dumps(s.memstats(), indent=4))
