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
- **01 Claude:** a still of a real run (the shimmering Claude panel and the
  timeline glow) and what Claude's 37 tools cover.
- **02 Rounds of notes:** the notes video (a Feedback marker, a `/` mention,
  Claude's fix, the automatic _V2 and z_OLD CUTS, the review prompt) and three
  close-up stills.
- **03 By hand:** the trim, viewer box and source monitor videos in tabs, then
  stills of Speed/Duration, Fit Clip and Properties.
- Stills open in a `<dialog>` lightbox (focus moves in and back, Esc closes).
- **04 Color:** before/after slider, B cam S-Log3 vs. its LUT
  (`grade-log`, `grade-lut`), a range input for keyboard access.
- **05 Transcript:** real words and timings from the A cam transcript,
  highlighted at real speed.
- Reduced motion: no reveals, and nothing
  autoplays. Without JS everything is visible.

Fonts are self-hosted from Google Fonts (all SIL Open Font License):
Instrument Sans, Instrument Serif (italic), JetBrains Mono, latin subset only.

## Videos

All five are real recordings of Speedrun 0.4.1 (2026-11-21) on the Scott
Stroud interview (published with the user's OK, 2026-11-18). The Claude runs
are real; clicks, keys and typing were sent through Speedrun's test hooks (the
same calls the UI makes: `speedrun/transport`, `speedrun/source`,
`speedrun/trim`, `speedrun/viewer_box`, and `speedrun/prompt` for typing in
the Claude box), so no pointer is shown. Recipe in `tools/recording/`:

1. `swiftc -O wrec.swift -o wrec`: records one window with ScreenCaptureKit,
   even when it's covered, until `/tmp/srtest/rec/stop` exists.
2. A copy of the app in `/tmp/srtest/demo/Speedrun.app`, launched hidden on a
   copy of the project (`launch.sh <project> 1600 960`), with `agent.json`
   snapshotted so the scripts only ever talk to that copy.
3. Takes: `hero_take.sh` (project reset by `reset_hero.py`, prompt in
   `hero_prompt.txt`); then, on a copy of the finished hero project,
   `notes_take.py <wid> 1500 rec`, `trim41_take.sh`, `xform41_take.py`
   and `source41_take.py`.
4. `encode.sh`: crops (title bar off; the trim clip stacks the A/B monitors
   over the ruler and tracks, the source clip stacks both monitors over the
   timeline), speeds up Claude's work (hero 12×, notes 6×), H.264 High@4.0
   CRF 22–27, faststart, no audio. Posters are the first frame of each encode.

Stills are window captures (`screencapture -x -o -l <wid>`) of the same
instance, cropped with ffmpeg; a sheet (Speed/Duration, Fit Clip) is in the
window's capture. Lossless crops are in `tools/originals/`.

## Images

- `speedrun-wordmark-dark-bg.svg`: the "speed|run" playhead wordmark (outlined
  JetBrains Mono 800, from the logo kit). The header and footer inline the same
  SVG so the playhead color can change on hover.
- `favicon.svg`, `favicon.ico`, `apple-touch-icon.png`, `icon-192/512.png`:
  the web set from the app icon kit (the s|r playhead monogram).
- `app-icon.png`: the macOS icon master (1024, Apple grid with shadow), used
  by the OG image. The app bundles the same art as `Resources/AppIcon.icns`.
- `editor.jpg` (used by the OG image): a window screenshot of the finished
  0.4.1 hero project, title bar cropped; the original is
  `tools/originals/editor.png`.
- Color slider: frames of the B camera file with `ffmpeg -ss <t>`, graded
  with `lut3d=<camera .cube>`, scaled with lanczos.
- AVIF via `avifenc -q 70–72 -s 4 -y 420 --cicp 1/13/1 -r full`, JPEG
  fallbacks at q3–4.
- `og.jpg`: `tools/og.html` rendered by headless Chrome at 1200×630, then
  JPEG q85.
