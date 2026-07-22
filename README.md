# BT Sound Keeper for Linux

Keeps a Bluetooth speaker (or headset) from auto-disconnecting due to
inactivity, by quietly playing an almost inaudible tone every few minutes.

Packaged as a single portable `.AppImage` — no installation, no dependencies
to set up manually.

[![Build AppImage](../../actions/workflows/build-appimage.yml/badge.svg)](../../actions/workflows/build-appimage.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## For everyone: download and run

1. Go to the **[Releases](../../releases/latest)** page and download
   `BT_Sound_Keeper_for_Linux.AppImage`.
2. Make it executable and run it:

   ```bash
   chmod +x BT_Sound_Keeper_for_Linux.AppImage
   ./BT_Sound_Keeper_for_Linux.AppImage
   ```

3. On first run, you'll be asked whether to add it to autostart. Say yes,
   and it'll keep running quietly in the background every time you log in.

That's it — everything needed (a bundled static `ffplay`) is packed inside
the AppImage, nothing else to install.

**To stop it permanently**, remove the autostart entry and close the app:

```bash
rm -f ~/.config/autostart/bt-sound-keeper.desktop
```

**Logs**, if you ever need to check what it's doing, are at:

```bash
cat ~/.config/bt-sound-keeper.log
```

---

## For developers: build from source

<details>
<summary>Click to expand build instructions, repo layout, and configuration</summary>

### Requirements

- `bash`, `wget`, `tar`
- `zenity` (optional — used for the autostart confirmation dialog; falls
  back to a plain terminal prompt if not installed)

### Build

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd <your-repo>
chmod +x build-appimage.sh
./build-appimage.sh
```

The build script downloads a static `ffplay` build, assembles an `AppDir/`,
and packages it all into `~/AppImages/BT_Sound_Keeper_for_Linux.AppImage`.

### Repo layout

| File | Purpose |
|---|---|
| `AppRun` | Entry point executed inside the AppImage. Runs the keep-alive tone loop and manages the autostart entry (including self-healing a stale entry after the AppImage is moved/renamed/rebuilt). |
| `bt-sound-keeper.desktop` | Desktop entry bundled *inside* the AppImage (used for app-menu integration, e.g. via AppImageLauncher). |
| `build-appimage.sh` | Downloads a static `ffplay`, assembles `AppDir/`, and packages everything into the final `.AppImage`. |
| `.github/workflows/build-appimage.yml` | CI: builds the AppImage on every push; publishes it to GitHub Releases when a `v*` tag is pushed. |

### Configuration

Adjustable at the top of `AppRun`:

```sh
INTERVAL_MIN=4   # how often to play the keep-alive tone (minutes)
FREQUENCY=15     # tone frequency in Hz (kept low / near-inaudible)
DURATION_SEC=5   # duration of each pulse (seconds)
VOLUME=1         # playback volume
```

### How autostart works

- On first run, `AppRun` asks (via `zenity`, or a terminal prompt as
  fallback) whether to create `~/.config/autostart/bt-sound-keeper.desktop`.
- The entry's `Exec=` points to `$APPIMAGE` (the real, persistent path to
  the `.AppImage` file), not to the temporary FUSE mount path — so it
  keeps working across reboots and after the app closes.
- If the entry ever goes stale (AppImage moved, renamed, or rebuilt), it's
  silently repaired on next run — no repeated prompts.
- The autostart entry's icon is copied once to
  `~/.local/share/bt-sound-keeper/` so it keeps displaying correctly even
  when the AppImage isn't mounted.

### Releasing a new version

Push a tag matching `v*` and CI builds the AppImage and attaches it to a
new GitHub Release automatically:

```bash
git tag v1.0.1
git push origin v1.0.1
```

</details>

---

## Contributing

Issues and pull requests are welcome — this is a small, focused tool, so
keep changes simple and in line with the existing style.

## License

Licensed under the [MIT License](LICENSE).
