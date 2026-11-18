# speedrun-app

Download page for **Speedrun** (the macOS video editor where Claude builds
the first cut), served by GitHub Pages at
https://tlatvys-ac.github.io/speedrun-app/. Releases on this repo carry the
download, `Speedrun-<v>.dmg`, built in the private Speedrun repo by
`scripts/make-dmg.sh`.

Built to the shared download-site rules (reference:
`refractlab-app/index.html`). Two deliberate differences: the hero video uses
the gallery width (1080px) because an editor's UI is unreadable at 756px, and
the features are shown as video-beside-text rows ("See it work") ahead of the
still gallery.

## Videos

All five are real recordings of Speedrun 0.2.0 on the Scott Stroud
interview (published with the user's OK, 2026-11-18). The Claude runs are
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

- `logo.png`, favicons, `apple-touch-icon.png`: from Speedrun's
  `Resources/AppIcon.icns` (`iconutil -c iconset`).
- `editor`, `transcript`, `properties`: window screenshots
  (`screencapture -o -l <wid>`) kept losslessly in `tools/originals/`.
  The editor is scaled to 2400 wide; the panels are 938×1044 crops at
  (2822, 56). AVIF via `avifenc -q 72 -s 4 -y 420 --cicp 1/13/1 -r full`;
  fallback JPEG q85 for the editor, PNG for the panels (smaller).
- `og.jpg`: `tools/og.html` rendered by headless Chrome at 1200×630, then
  JPEG q85.
