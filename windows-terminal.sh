#!/usr/bin/env bash
# Run from WSL: installs a Nerd Font for the current Windows user and points the
# Windows Terminal WSL profiles at it with the catppuccin mocha colour scheme.
set -euo pipefail

FONT_ZIP="JetBrainsMono"                 # nerd-fonts release asset name
FONT_FACE="JetBrainsMono Nerd Font"      # face name Windows Terminal uses

WIN_LOCALAPPDATA="$(wslpath "$(powershell.exe -NoProfile -Command '$env:LOCALAPPDATA' | tr -d '\r')")"
SETTINGS="$(ls "$WIN_LOCALAPPDATA"/Packages/Microsoft.WindowsTerminal_*/LocalState/settings.json | head -1)"

echo "==> installing $FONT_FACE (per-user, no admin)"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
curl -fsSL -o "$tmp/font.zip" "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/$FONT_ZIP.zip"
unzip -oq "$tmp/font.zip" -d "$tmp/font"
fontdir="$WIN_LOCALAPPDATA/Microsoft/Windows/Fonts"
mkdir -p "$fontdir"
for f in "$tmp"/font/"$FONT_ZIP"NerdFont-*.ttf; do
  name="$(basename "$f")"
  cp "$f" "$fontdir/$name"
  winpath="$(wslpath -w "$fontdir/$name")"
  powershell.exe -NoProfile -Command "New-ItemProperty -Force -Path 'HKCU:\\Software\\Microsoft\\Windows NT\\CurrentVersion\\Fonts' -Name '${name%.ttf} (TrueType)' -Value '$winpath' | Out-Null"
done

echo "==> updating $SETTINGS"
cp "$SETTINGS" "$SETTINGS.bak.$(date +%s)"
python3 - "$SETTINGS" "$FONT_FACE" <<'PY'
import json, sys
path, face = sys.argv[1], sys.argv[2]
s = json.load(open(path, encoding="utf-8"))
mocha = {
    "name": "Catppuccin Mocha",
    "cursorColor": "#F5E0DC", "selectionBackground": "#585B70",
    "background": "#1E1E2E", "foreground": "#CDD6F4",
    "black": "#45475A", "red": "#F38BA8", "green": "#A6E3A1", "yellow": "#F9E2AF",
    "blue": "#89B4FA", "purple": "#F5C2E7", "cyan": "#94E2D5", "white": "#BAC2DE",
    "brightBlack": "#585B70", "brightRed": "#F38BA8", "brightGreen": "#A6E3A1",
    "brightYellow": "#F9E2AF", "brightBlue": "#89B4FA", "brightPurple": "#F5C2E7",
    "brightCyan": "#94E2D5", "brightWhite": "#A6ADC8",
}
s["schemes"] = [x for x in s.get("schemes", []) if x.get("name") != mocha["name"]] + [mocha]
for p in s["profiles"]["list"]:
    if p.get("source") == "Windows.Terminal.Wsl" or "Ubuntu" in p.get("name", ""):
        p["colorScheme"] = mocha["name"]
        p.setdefault("font", {})["face"] = face
        print("  profile:", p["name"], p["guid"])
json.dump(s, open(path, "w", encoding="utf-8"), indent=4, ensure_ascii=False)
PY
echo "Done. Restart Windows Terminal to pick up the font."
