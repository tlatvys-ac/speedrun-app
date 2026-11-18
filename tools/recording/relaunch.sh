#!/bin/zsh
# relaunch.sh <name> [w h]: kills the demo instance, installs the latest build, opens a fresh copy of built/ as <name>/
D=/tmp/srtest/demo
pid=$(python3 -c "import json;print(json.load(open('$D/agent.json'))['pid'])")
ps -p $pid -o args= | grep -q $D/Speedrun.app && kill $pid && sleep 1.5
cp ~/Documents/GitHub/Speedrun/.build/release/Speedrun $D/Speedrun.app/Contents/MacOS/Speedrun
codesign --force --sign "Speedrun Local Signing" --timestamp=none $D/Speedrun.app 2>/dev/null
mkdir -p $D/$1; rm -rf "$D/$1/Town Hall.speedrun"; cp -R "$D/built/Town Hall.speedrun" "$D/$1/"
[ -d "$D/$1/Town Hall Media" ] || cp -c -R "$D/hero/Town Hall Media" "$D/$1/"
python3 - "$D/$1" <<'PY'
import json,sys,os
if os.environ.get('NOCHAT') and os.path.exists(sys.argv[1]+'/Town Hall.speedrun/chat.json'): os.remove(sys.argv[1]+'/Town Hall.speedrun/chat.json')
f=sys.argv[1]+'/Town Hall.speedrun/project.json'; s=open(f).read().replace('/tmp/srtest/demo/hero/', sys.argv[1]+'/'); open(f,'w').write(s)
PY
$D/launch.sh "$D/$1/Town Hall.speedrun" ${2:-1600} ${3:-960}
