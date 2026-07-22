#!/bin/bash
set -e
# =============================================
# BT Sound Keeper for Linux - Build Script
# =============================================
APP_NAME="BT Sound Keeper for Linux"
FINAL_NAME="BT_Sound_Keeper_for_Linux.AppImage"
echo "Building $APP_NAME"
# Prepare clean AppDir
rm -rf AppDir
mkdir -p AppDir/usr/bin AppDir/usr/lib
# Download static ffplay (newer version)
echo "Downloading static ffplay..."
wget -q https://github.com/BtbN/FFmpeg-Builds/releases/download/latest/ffmpeg-n7.1-latest-linux64-gpl-7.1.tar.xz -O ffmpeg.tar.xz
tar -xf ffmpeg.tar.xz
cp ffmpeg-n7.1-latest-linux64-gpl-7.1/bin/ffplay AppDir/usr/bin/ffplay
chmod +x AppDir/usr/bin/ffplay
# Copy libraries
cp -a ffmpeg-n7.1-latest-linux64-gpl-7.1/lib/* AppDir/usr/lib/ 2>/dev/null || true
# Cleanup
rm -rf ffmpeg-n7.1-latest-linux64-gpl-7.1 ffmpeg.tar.xz
# Copy application files
cp AppRun AppDir/
cp bt-sound-keeper.desktop AppDir/
# Download icon
echo "Downloading icon..."
wget -q https://raw.githubusercontent.com/google/material-design-icons/abd7f5c0e179c83f068c770650bd14ebac5d5a09/symbols/web/bluetooth_searching/materialsymbolssharp/bluetooth_searching_48px.svg -O AppDir/bluetooth.svg
chmod +x AppDir/AppRun
# Build AppImage with fixed name
echo "Building AppImage..."
wget -q https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -O appimagetool
chmod +x appimagetool
# --appimage-extract-and-run avoids relying on FUSE being available/mounted
# on the host (CI runners, some minimal desktop setups). Works fine
# everywhere else too, so we use it unconditionally.
ARCH=x86_64 ./appimagetool --appimage-extract-and-run AppDir "$FINAL_NAME"
# Move to ~/AppImages
mkdir -p "$HOME/AppImages"
mv "$FINAL_NAME" "$HOME/AppImages/"
echo "✅ Build completed successfully!"
echo "AppImage saved as: $HOME/AppImages/$FINAL_NAME"
