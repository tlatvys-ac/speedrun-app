#!/bin/bash
# Crops and cut points for the 0.4.1 takes (1600x960 window, 3200x1920 raw; the title bar is the top 64 px).
cd /tmp/srtest/demo; O=/tmp/srtest/site41/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
ffmpeg -v error -y -i hero_raw.mov -filter_complex "[0]crop=3200:1848:0:64,scale=1600:-2:flags=lanczos,split=3[a][b][c];[a]trim=0:4.5,setpts=PTS-STARTPTS[s1];[b]trim=4.5:240.5,setpts=(PTS-STARTPTS)/12[s2];[c]trim=240.5:258.5,setpts=PTS-STARTPTS[s3];[s1][s2][s3]concat=n=3,fps=30[v]" -map "[v]" $ENC -crf 27 $O/hero.mp4
ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $O/hero.mp4
cd /tmp/srtest/demo; O=/tmp/srtest/site41/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
ffmpeg -v error -y -i notes_raw.mov -filter_complex "[0]crop=3200:1848:0:64,scale=1600:-2:flags=lanczos,split=3[a][b][c];[a]trim=0:17,setpts=PTS-STARTPTS[s1];[b]trim=17:85,setpts=(PTS-STARTPTS)/6[s2];[c]trim=85,setpts=PTS-STARTPTS[s3];[s1][s2][s3]concat=n=3,fps=30[v]" -map "[v]" $ENC -crf 26 $O/notes.mp4
ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $O/notes.mp4
cd /tmp/srtest/demo; O=/tmp/srtest/site41/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
ffmpeg -v error -y -i trim41_raw.mov -filter_complex "[0]trim=3.6:24.2,setpts=PTS-STARTPTS,split=3[a][b][c];[a]crop=1048:366:2144:354[m];[b]crop=1048:60:1159:1124[r];[c]crop=1048:290:1159:1370[t];[m][r][t]vstack=3,fps=30[v]" -map "[v]" $ENC -crf 22 $O/trim.mp4
ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $O/trim.mp4
ffmpeg -v error -y -ss 9 -i $O/trim.mp4 -frames:v 1 /tmp/srtest/site41/trim_check.png
cd /tmp/srtest/demo; O=/tmp/srtest/site41/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
ffmpeg -v error -y -i xform41_raw.mov -vf "trim=1.6,setpts=PTS-STARTPTS,crop=1054:776:2140:190,fps=30" $ENC -crf 22 $O/transform.mp4
ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $O/transform.mp4
ffmpeg -v error -y -ss 5 -i $O/transform.mp4 -frames:v 1 /tmp/srtest/site41/xf_check.png
cd /tmp/srtest/demo; O=/tmp/srtest/site41/media; ENC="-c:v libx264 -preset slow -pix_fmt yuv420p -movflags +faststart -an -profile:v high -level:v 4.0"
ffmpeg -v error -y -i source41_raw.mov -filter_complex "[0]trim=1.2,setpts=PTS-STARTPTS,split=2[a][b];[a]crop=2128:960:1070:64[m];[b]crop=2128:540:1070:1120[t];[m][t]vstack=2,scale=1200:-2:flags=lanczos,fps=30[v]" -map "[v]" $ENC -crf 22 $O/source.mp4
ffprobe -v error -show_entries stream=width,height:format=duration,size -of csv=p=0 $O/source.mp4
ffmpeg -v error -y -ss 8 -i $O/source.mp4 -frames:v 1 /tmp/srtest/site41/src_check.png
