#!/bin/bash
O=/tmp/srtest/site/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
cd /tmp/srtest/demo
ffmpeg -v error -y -i hero_raw.mov -filter_complex "[0]crop=3200:1864:0:56,scale=1800:-2:flags=lanczos,split=3[a][b][c];[a]trim=0:4.5,setpts=PTS-STARTPTS[s1];[b]trim=4.5:161.5,setpts=(PTS-STARTPTS)/12[s2];[c]trim=161.5:178,setpts=PTS-STARTPTS[s3];[s1][s2][s3]concat=n=3,fps=30[v]" -map "[v]" $ENC -crf 24 $O/hero.mp4
ffmpeg -v error -y -i markers_raw.mov -filter_complex "[0]crop=2840:1660:960:64,scale=1600:-2:flags=lanczos,split=3[a][b][c];[a]trim=0:13,setpts=PTS-STARTPTS[s1];[b]trim=13:66,setpts=(PTS-STARTPTS)/6[s2];[c]trim=66:72.5,setpts=PTS-STARTPTS[s3];[s1][s2][s3]concat=n=3,fps=30[v]" -map "[v]" $ENC -crf 24 $O/markers.mp4
ffmpeg -v error -y -i trim_raw.mov -filter_complex "[0]trim=4.15:20.3,setpts=PTS-STARTPTS,tpad=start_duration=0.8:start_mode=clone,split=3[a][b][c];[a]crop=940:330:1900:370[m];[b]crop=940:70:1426:1110[r];[c]crop=940:290:1426:1370[t];[m][r][t]vstack=3,fps=30[v]" -map "[v]" $ENC -crf 22 $O/trim.mp4
ffmpeg -v error -y -i xform_raw.mov -vf "trim=1.6,setpts=PTS-STARTPTS,crop=1900:1000:1900:64,scale=1280:-2:flags=lanczos,fps=30" $ENC -crf 22 $O/transform.mp4
ffmpeg -v error -y -i source_raw.mov -vf "trim=1.2,setpts=PTS-STARTPTS,crop=2000:1660:850:64,scale=1080:-2:flags=lanczos,fps=30" $ENC -crf 22 $O/source.mp4
for f in $O/*.mp4; do printf "%s " $(basename $f); ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $f | tr '\n' ' '; echo; done
