
import subprocess
import math


def fmtM(val):
    if val >= 1000:
        return "%.1fG" % (val/1000)
    if val >= 10:
        return "%dM" % val
    else:
        return "%.1fM" % val


class Py3status:
    cache_timeout = 1

    def _cmd(self, cmd):
        cmd = subprocess.Popen(cmd, stdout=subprocess.PIPE)
        return cmd.stdout.readlines()

    def memstats(self):
        bad = {}

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

        bad["swap"] = max(0, 10 * swpU / swpT)
        bad["mem"] = max(0, (0.5 * memT / memA) - 1)

        mem = {}
        cpu = {}
        cpuTotal = 0

        for l in self._cmd(["ps", "aux"]):
            arr = l.split()

            if arr[0] == b"USER":
                continue

            arr[10] = arr[10].decode("utf-8").split("/")[-1]

            if arr[10] not in mem:
                mem[arr[10]] = 0
            if arr[10] not in cpu:
                cpu[arr[10]] = 0

            cpu[arr[10]] += float(arr[2])
            cpuTotal += float(arr[2])
            mem[arr[10]] += int(arr[5])

        items = []
        if swpU > 0:
            items.append("SWP: %s/%s" % (fmtM(swpU), fmtM(swpT)))

        memitems = ["%s/%s F=%s A=%s" % (fmtM(memU),
                                         fmtM(memT),
                                         fmtM(memF),
                                         fmtM(memA))]
        for v, k in reversed(sorted([(mem[a], a) for a in mem])[-3:]):
            memitems.append("%s=%s" % (k, fmtM(v / 1000)))

        items.append(" ".join(memitems))

        cpuitems = ["%.1f%%" % cpuTotal]
        for v, k in reversed(sorted([(cpu[a], a) for a in cpu])[-3:]):
            cpuitems.append("%s=%.1f" % (k, v))
        items.append(" ".join(cpuitems))

        bad["cpu"] = max(0, cpuTotal / 100 - 1)

        with open("/proc/loadavg", "r") as f:
            la = [float(n) for n in f.read().split(" ")[:3]]

        bad["swp0"] = max(0, (la[0]-4) / 4)
        bad["swp1"] = max(0, (la[1]-4) / 6)
        bad["swp2"] = max(0, (la[2]-4) / 8)
        items.append("%.2f %.2f %.2f" % (la[0], la[1], la[2]))

        total = 0
        for cat in bad:
            total += bad[cat]

        items.append("%.2f" % total)
        bf = min(6, total) / 6
        red = int(255 * math.sqrt(bf))
        green = int(255 * math.sqrt(1-bf))
        color = "#%0.2x%0.2x00" % (red, green)

        return {"full_text": " | ".join(items), "color": color}
