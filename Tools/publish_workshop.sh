#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(dirname "$SCRIPT_DIR")"
VDF_PATH="$ROOT_DIR/workshop_item.vdf"

echo "========================================================"
echo " Publishing A3UE Mafia PvPvEvE Extender to Steam Workshop"
echo "========================================================"

STEAMCMD_BIN="$(which steamcmd 2>/dev/null || true)"

if [ -z "$STEAMCMD_BIN" ]; then
    echo ""
    echo "[!] steamcmd executable not found in PATH."
    echo ""
    echo "To publish via SteamCMD on Linux:"
    echo "  1. Install steamcmd: sudo apt-get install steamcmd"
    echo "  2. Run: steamcmd +login <your_username> +workshop_build_item \"$VDF_PATH\" +quit"
    echo ""
    echo "Alternatively, use the Arma 3 Publisher tool from Arma 3 Tools on Windows:"
    echo "  Directory to publish: $ROOT_DIR/build/@A3UE_Mafia"
    echo ""
    exit 1
fi

read -p "Enter your Steam username: " STEAM_USER
echo "Launching SteamCMD..."
"$STEAMCMD_BIN" +login "$STEAM_USER" +workshop_build_item "$VDF_PATH" +quit
