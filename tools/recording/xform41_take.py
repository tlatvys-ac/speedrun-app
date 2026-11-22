import json, urllib.request, time, math, subprocess, sys, os
info = json.load(open('/tmp/srtest/demo/agent.json'))
def call(method, params):
    req = urllib.request.Request(f"http://127.0.0.1:{info['port']}/mcp", method="POST",
        data=json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode(),
        headers={"Authorization": "Bearer " + info["token"], "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=60)).get("result")
def tool(name, args): return call("tools/call", {"name": name, "arguments": args})
ids = json.loads(sys.argv[1]); wid = sys.argv[2]
tool("seek", {"at": "01:00:03:12"})
call("speedrun/transport", {"action": "tab", "tab": "Program"})   # the panel the take shows updating
call("speedrun/viewer_box", {"clip": "nothing"})
try: os.remove('/tmp/srtest/rec/stop')
except FileNotFoundError: pass
rec = subprocess.Popen(['/tmp/srtest/rec/wrec', wid, '/tmp/srtest/demo/xform41_raw.mov'])
time.sleep(2.5)
call("speedrun/viewer_box", {"clip": ids[0][:8]})   # = double-click
time.sleep(1.2)
st = dict(x=1000, y=420, scale=1.0, rotation=0)
def ease(u): return 0.5 - 0.5 * math.cos(math.pi * u)
def go(dur, **target):
    a = dict(st); n = int(dur * 30)
    for i in range(1, n + 1):
        u = ease(i / n)
        cur = {k: a[k] + (target.get(k, a[k]) - a[k]) * u for k in a}
        call("speedrun/viewer_box", {"clip": ids[0][:8], "transform": cur})
        time.sleep(1 / 30)
    st.update(target)
go(1.3, x=640, y=300)          # drag to move
time.sleep(0.5)
go(1.1, scale=1.4)              # corner drag to scale
time.sleep(0.5)
go(0.9, rotation=-8)            # rotate
time.sleep(0.3)
go(0.7, rotation=0)
time.sleep(0.4)
# mouse-up commits it (both halves of the graphic)
tool("update_clips", {"clips": ids, "x": st['x'], "y": st['y'], "scale": st['scale'], "rotation": 0})
call("speedrun/viewer_box", {"clip": ids[0][:8]})
time.sleep(2.5)
open('/tmp/srtest/rec/stop', 'w').close(); rec.wait()
