import json, urllib.request, time, subprocess, sys, os
info = json.load(open('/tmp/srtest/demo/agent.json'))
def call(method, params):
    req = urllib.request.Request(f"http://127.0.0.1:{info['port']}/mcp", method="POST",
        data=json.dumps({"jsonrpc": "2.0", "id": 1, "method": method, "params": params}).encode(),
        headers={"Authorization": "Bearer " + info["token"], "Content-Type": "application/json"})
    return json.load(urllib.request.urlopen(req, timeout=60)).get("result")
def tr(**a): return call("speedrun/transport", a)
def src(**a): return call("speedrun/source", a)
wid = sys.argv[1]
tr(action="seek", frame=1036); tr(action="zoom_range", **{"from": 640, "to": 1640}); tr(action="tab", tab="Project"); tr(action="tab", tab="Source"); tr(action="tab", tab="Program")
time.sleep(1.5); tr(action="zoom_range", **{"from": 640, "to": 1640}); time.sleep(0.5)
try: os.remove('/tmp/srtest/rec/stop')
except FileNotFoundError: pass
rec = subprocess.Popen(['/tmp/srtest/rec/wrec', wid, '/tmp/srtest/demo/source41_raw.mov'])
time.sleep(2.0)
print(src(action="load", asset="Scott_B CAM_WS_C0252", at=402.0)); time.sleep(1.8)   # double-click in the Project panel
src(action="in"); time.sleep(0.6)                                                   # I
src(action="play"); time.sleep(3.4); src(action="pause"); time.sleep(0.4)          # Space … Space
src(action="out"); time.sleep(1.4)                                                  # O
print(src(action="insert")); time.sleep(2.5)                                        # ,
open('/tmp/srtest/rec/stop', 'w').close(); rec.wait()
