import json, urllib.request, time, subprocess, sys, os, re
info = json.load(open('/tmp/srtest/demo/agent.json'))
def call(method, params):
    req = urllib.request.Request(f"http://127.0.0.1:{info['port']}/mcp", method="POST",
        data=json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode(),
        headers={"Authorization": "Bearer " + info["token"], "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=900)).get("result")
def tool(name, args): return call("tools/call", {"name": name, "arguments": args})
def tr(**a): return call("speedrun/transport", a)
wid = sys.argv[1]
tr(action="zoom_fit"); tr(action="seek", frame=1860); tr(action="tab", tab="Markers")
time.sleep(1)
try: os.remove('/tmp/srtest/rec/stop')
except FileNotFoundError: pass
rec = subprocess.Popen(['/tmp/srtest/rec/wrec', wid, '/tmp/srtest/demo/markers_raw.mov'])
time.sleep(2.5)
t = {}
t['m1'] = time.time(); tr(action="marker_key")            # M: adds a marker
time.sleep(1.8)
txt = tool("get_markers", {})["content"][0]["text"]
mid = re.search(r"\[([0-9a-f]{6,})\]", txt).group(1)
tool("edit_markers", {"markers": [{"id": mid, "name": "Tighten this shot", "note": "This one drags. Lose a couple of seconds, but don't cut him off mid-sentence.", "color": "red", "tags": ["Feedback"]}]})
t['m2'] = time.time(); tr(action="marker_key")            # M again: the editor
time.sleep(4.5)
tr(action="close_sheet")
time.sleep(1.8)
tr(action="tab", tab="Claude")
time.sleep(1)
t['send'] = time.time()
call("speedrun/send", {"text": "I left you a feedback marker. Can you take care of it?"})
while True:
    time.sleep(2)
    if not call("speedrun/chat", {})["running"]: break
t['done'] = time.time()
time.sleep(3)
tr(action="zoom_fit")
tr(action="tab", tab="Markers")
time.sleep(3.5)
open('/tmp/srtest/rec/stop', 'w').close(); rec.wait()
t0 = t['m1'] - 2.5
print({k: round(v - t0, 2) for k, v in t.items()})
print(call("speedrun/chat", {})["messages"][-1]["text"])
