"""0.4.1 notes take: M adds a Feedback marker, the note is typed, the marker is mentioned with
/ in the Claude box, Claude handles it (the cut is versioned into z_OLD CUTS automatically) and
Speedrun asks whether to delete the addressed marker. Run: python3 notes_take.py <wid> <frame> [rec]"""
import json, urllib.request, time, subprocess, sys, os, re
info = json.load(open('/tmp/srtest/demo/agent.json'))
def call(method, params):
    req = urllib.request.Request(f"http://127.0.0.1:{info['port']}/mcp", method="POST",
        data=json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode(),
        headers={"Authorization": "Bearer " + info["token"], "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=900)).get("result")
def tool(name, args): return call("tools/call", {"name": name, "arguments": args})
def tr(**a): return call("speedrun/transport", a)
def typ(s, dt=0.06):
    for ch in s: call("speedrun/prompt", {"text": ch}); time.sleep(dt)
def key(c): return call("speedrun/prompt", {"command": c})
wid, frame = sys.argv[1], int(sys.argv[2]); record = len(sys.argv) > 3
tr(action="zoom_fit"); tr(action="seek", frame=frame)
for t in ("Project", "Claude", "Program"): tr(action="tab", tab=t)
time.sleep(1)
if record:
    try: os.remove('/tmp/srtest/rec/stop')
    except FileNotFoundError: pass
    rec = subprocess.Popen(['/tmp/srtest/rec/wrec', wid, '/tmp/srtest/demo/notes_raw.mov'])
t = {}; t0 = time.time()
time.sleep(2.5)
t['m1'] = time.time(); tr(action="marker_key")            # M: adds a marker
time.sleep(1.5)
txt = tool("get_markers", {})["content"][0]["text"]
mid = re.findall(r"\[([0-9a-f]{6,})\]", txt)[-1]
tool("edit_markers", {"markers": [{"id": mid, "name": "Tighten this shot", "note": "This one drags. Lose a couple of seconds, but don't cut him off mid-sentence.", "color": "red", "tags": ["Feedback"]}]})
tr(action="marker_key")                                    # M again: the note
time.sleep(4.0)
tr(action="close_sheet"); time.sleep(1.2)
t['type'] = time.time()
typ("Take care of ")
typ("/feed", 0.12); time.sleep(1.3)
key("insertNewline:"); time.sleep(1.6)                     # completes /feedback and lists its markers
key("insertNewline:"); time.sleep(1.0)                     # picks the marker
typ("please.")
time.sleep(1.2)
t['send'] = time.time(); key("insertNewline:")
while True:
    time.sleep(2)
    if not call("speedrun/chat", {})["running"]: break
t['done'] = time.time()
time.sleep(1); tr(action="zoom_fit"); time.sleep(5)
if record:
    open('/tmp/srtest/rec/stop', 'w').close(); rec.wait()
print({k: round(v - t0, 2) for k, v in t.items()})
print(call("speedrun/chat", {})["messages"][-1]["text"])
