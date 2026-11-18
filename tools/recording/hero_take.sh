#!/bin/zsh
cd /tmp/srtest/demo
WID=$1
rm -f /tmp/srtest/rec/stop
/tmp/srtest/rec/wrec $WID hero_raw.mov > wrec_hero.log 2>&1 &
sleep 3
date +%s > hero_t0
python3 rpc.py speedrun/send "$(python3 -c 'import json;print(json.dumps({"text":open("hero_prompt.txt").read()}))')"
while true; do
  sleep 2
  python3 rpc.py speedrun/transport '{"action":"zoom_fit"}' >/dev/null
  r=$(python3 rpc.py speedrun/chat | python3 -c "import sys,ast; d=ast.literal_eval(sys.stdin.read()); print(d['running'])")
  [[ "$r" == "False" ]] && break
done
date +%s > hero_t1
sleep 3
python3 rpc.py speedrun/transport '{"action":"zoom_fit"}'; python3 rpc.py speedrun/transport '{"action":"seek","frame":0}'
sleep 1
python3 rpc.py speedrun/transport '{"action":"play"}'
sleep 14
python3 rpc.py speedrun/transport '{"action":"pause"}'
sleep 1
touch /tmp/srtest/rec/stop
sleep 3
cat wrec_hero.log
