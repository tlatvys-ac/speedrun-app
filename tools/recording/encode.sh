#!/bin/bash
# Crops and cut points for the 0.3.0 takes (hero 1600×960 window; the others 1880×1020 points).
O=/tmp/srtest/site/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
cd /tmp/srtest/demo
ffmpeg -v error -y -i hero_raw.mov -filter_complex "[0]crop=3200:1864:0:56,scale=1800:-2:flags=lanczos,split=3[a][b][c];[a]trim=0:4.5,setpts=PTS-STARTPTS[s1];[b]trim=4.5:215.5,setpts=(PTS-STARTPTS)/12[s2];[c]trim=215.5:233.5,setpts=PTS-STARTPTS[s3];[s1][s2][s3]concat=n=3,fps=30[v]" -map "[v]" $ENC -crf 24 $O/hero.mp4
ffmpeg -v error -y -i markers_raw.mov -filter_complex "[0]crop=2800:1680:960:62,scale=1600:-2:flags=lanczos,split=3[a][b][c];[a]trim=0:12.5,setpts=PTS-STARTPTS[s1];[b]trim=12.5:64.5,setpts=(PTS-STARTPTS)/6[s2];[c]trim=64.5:70.2,setpts=PTS-STARTPTS[s3];[s1][s2][s3]concat=n=3,fps=30[v]" -map "[v]" $ENC -crf 24 $O/markers.mp4
ffmpeg -v error -y -i trim_raw.mov -filter_complex "[0]trim=4.15:20.3,setpts=PTS-STARTPTS,tpad=start_duration=0.8:start_mode=clone,split=3[a][b][c];[a]crop=940:330:1890:370[m];[b]crop=940:70:1416:1104[r];[c]crop=940:290:1416:1364[t];[m][r][t]vstack=3,fps=30[v]" -map "[v]" $ENC -crf 22 $O/trim.mp4
ffmpeg -v error -y -i xform_raw.mov -vf "trim=1.6,setpts=PTS-STARTPTS,crop=1876:1000:1884:62,scale=1280:-2:flags=lanczos,fps=30" $ENC -crf 22 $O/transform.mp4
ffmpeg -v error -y -i source_raw.mov -vf "trim=1.2,setpts=PTS-STARTPTS,crop=2820:1680:0:62,scale=1200:-2:flags=lanczos,fps=30" $ENC -crf 22 $O/source.mp4
for f in $O/*.mp4; do printf "%s " $(basename $f); ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $f | tr '\n' ' '; echo; done
