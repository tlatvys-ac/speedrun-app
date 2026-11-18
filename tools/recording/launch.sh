#!/bin/zsh
# launch.sh <project> [w h] — starts a hidden copy of Speedrun on <project>, sizes its window,
# snapshots its agent.json to /tmp/srtest/demo/agent.json and prints "pid wid".
proj="$1"; W=${2:-1600}; H=${3:-960}
before=$(stat -f %m ~/Library/Caches/Speedrun/agent.json 2>/dev/null || echo 0)
open -g -n /tmp/srtest/demo/Speedrun.app --args --open "$proj"
for i in {1..60}; do
  sleep 0.5
  pid=$(python3 -c "import json,os;print(json.load(open(os.path.expanduser('~/Library/Caches/Speedrun/agent.json')))['pid'])" 2>/dev/null)
  if [[ -n "$pid" ]] && ps -p $pid -o args= | grep -q /tmp/srtest/demo/Speedrun.app; then break; fi
done
cp ~/Library/Caches/Speedrun/agent.json /tmp/srtest/demo/agent.json
sleep 2
osascript -e "tell application \"System Events\" to tell (first process whose unix id is $pid) to set position of window 1 to {40, 60}" \
          -e "tell application \"System Events\" to tell (first process whose unix id is $pid) to set size of window 1 to {$W, $H}" >/dev/null
sleep 1
wid=$(/tmp/srtest/winid $pid | sort -k4 -n -r | head -1 | cut -d' ' -f1)
echo "$pid $wid"
