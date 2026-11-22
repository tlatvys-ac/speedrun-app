#!/bin/zsh
# Trim-mode take (window id as $1), run from /tmp/srtest/demo after relaunch.sh trim 1900 1040.
R() { python3 rpc.py "$@" >/dev/null; }
R speedrun/trim '{"action":"exit"}'; R speedrun/transport '{"action":"seek","frame":840}'; R speedrun/transport '{"action":"zoom_range","from":650,"to":1080}'; sleep 1
rm -f /tmp/srtest/rec/stop; (/tmp/srtest/rec/wrec $1 trim41_raw.mov > wrec_trim.log 2>&1 &); sleep 2.5
R speedrun/trim '{"action":"select","left":"016dab","side":"both"}'; sleep 1.5
R speedrun/trim '{"action":"enter"}'; sleep 2
for i in 1 2 3 4 5 6; do R speedrun/trim '{"action":"nudge","frames":-1}'; sleep 0.35; done; sleep 1
R speedrun/trim '{"action":"side","side":"right"}'; sleep 1.2
R speedrun/trim '{"action":"jkl","key":"l"}'; sleep 1.6; R speedrun/trim '{"action":"jkl","key":"k"}'; sleep 1.5
R speedrun/trim '{"action":"side","side":"left"}'; sleep 1.2
R speedrun/trim '{"action":"jkl","key":"l"}'; sleep 1.3; R speedrun/trim '{"action":"jkl","key":"k"}'; sleep 1.5
R speedrun/trim '{"action":"side","side":"both"}'; sleep 0.8
R speedrun/trim '{"action":"play_edit"}'; sleep 4.8
R speedrun/trim '{"action":"exit"}'; sleep 1.5
touch /tmp/srtest/rec/stop
