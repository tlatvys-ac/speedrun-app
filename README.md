# speedrun-app

Download page for **Speedrun** (the macOS video editor where Claude builds
the first cut), served by GitHub Pages at
https://tlatvys-ac.github.io/speedrun-app/. Releases on this repo carry the
download, `Speedrun-<v>.dmg`, built in the private Speedrun repo by
`scripts/make-dmg.sh`.

This page deliberately breaks from the shared download-site template
(`refractlab-app/index.html`): it's a product-launch page in the style of
caddis.app, one long dark page of big headlines that reveal word by word,
numbered sections, and interactive mockups. Everything is in `index.html`
(no build step, no dependencies):

- **Nav:** a timecode that runs 01:00:00:00 → 01:01:56:05 (the length of
  the demo cut) as you scroll, with a progress line.
- **01 Claude:** an animated replay of the hero run, built from the real
  project: the prompt, condensed tool calls with their real results, and the
  20 real V1 clips (start/duration in frames) landing on the timeline, then
  the viewer playing the cut. Viewer frames are `viewer-log`, `viewer-lut`
  (A cam) and `viewer-b` (B cam); `lower-third.png` is placed exactly as in
  the project (scale 1.2 at x 1384, y 586 on 3840×2160).
- **04 Color:** before/after slider, B cam S-Log3 vs. its LUT
  (`grade-log`, `grade-lut`), a range input for keyboard access.
- **05 Transcript:** real words and timings from the A cam transcript,
  highlighted at real speed.
- Reduced motion: no reveals, the replay shows its final state, and nothing
  autoplays. Without JS everything is visible.

Fonts are self-hosted from Google Fonts (all SIL Open Font License):
Instrument Sans, Instrument Serif (italic), JetBrains Mono, latin subset only.

## Videos

All five are real recordings of Speedrun 0.3.0 on the Scott Stroud
interview (published with the user's OK, 2026-11-18; re-recorded for 0.3.0 on 2026-11-19). The Claude runs are
real; the clicks and keys were sent through Speedrun's test hooks (the same
calls the UI makes), so no pointer is shown. Recipe in `tools/recording/`:

1. `swiftc -O wrec.swift -o wrec`: records one window with ScreenCaptureKit,
   even when it's covered, until `/tmp/srtest/rec/stop` exists.
2. A copy of the app in `/tmp/srtest/demo/Speedrun.app`, launched hidden on a
   copy of the project (`launch.sh` / `relaunch.sh <name> 1900 1040`), with
   `agent.json` snapshotted so the scripts only ever talk to that copy.
3. Takes: `hero_take.sh` (1600×960 window, project reset by `reset_hero.py`,
   prompt in `hero_prompt.txt`), `trim_take.sh`, `xform_take.py`,
   `markers_take.py` (fresh chat), `source_take.py`.
4. `encode.sh`: crops (title bar off; the trim clip stacks the A/B monitors
   over the ruler and tracks), speeds up Claude's work (hero 12×, markers 6×),
   H.264 High@4.0 CRF 22–24, faststart, no audio. Posters are frames of the
   encodes (`ffmpeg -ss … -frames:v 1 -q:v 3/5`).

## Images

- `speedrun-wordmark-dark-bg.svg`: the "speed|run" playhead wordmark (outlined
  JetBrains Mono 800, from the logo kit). The header and footer inline the same
  SVG so the playhead color can change on hover.
- `favicon.svg`, `favicon.ico`, `apple-touch-icon.png`, `icon-192/512.png`:
  the web set from the app icon kit (the s|r playhead monogram).
- `app-icon.png`: the macOS icon master (1024, Apple grid with shadow), used
  by the OG image. The app bundles the same art as `Resources/AppIcon.icns`.
- `editor.jpg` (used by the OG image): a window screenshot of the hero project
  (`screencapture -o -l <wid>`, title bar cropped), kept losslessly as
  `tools/originals/editor.png`.
- Footage stills: frames of the camera files with `ffmpeg -ss <t>`, graded
  with `lut3d=<camera .cube>` where needed (A cam at 24 s, B cam at 30.5 s),
  scaled with lanczos. The lower third is frame 4 s of `Scott Stroud_L3_V5.mov`.
- AVIF via `avifenc -q 70–72 -s 4 -y 420 --cicp 1/13/1 -r full`, JPEG
  fallbacks at q3–4.
- `og.jpg`: `tools/og.html` rendered by headless Chrome at 1200×630, then
  JPEG q85.
