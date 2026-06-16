#!/usr/bin/env bash

# Color scheme definitions
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0;37m' # No Color

echo -e "${CYAN}🚀 Starting hypr-audio-hud installation wrapper...${NC}"

# 1. Detect environment and dependencies
echo -e "${CYAN}🔍 Checking system prerequisites...${NC}"
DEPENDENCIES=(ghostty cava fzf pipewire-utils wireplumber ncurses)
MISSING_DEPS=()

for dep in "${DEPENDENCIES[@]}"; do
    if ! command -v "$dep" &> /dev/null; then
        MISSING_DEPS+=("$dep")
    fi
done

# 2. Install dependencies automatically if missing
if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${YELLOW}📦 Missing dependencies detected: ${MISSING_DEPS[*]}${NC}"
    if command -v yay &> /dev/null; then
        echo -e "${GREEN}Syncing dependencies via yay...${NC}"
        yay -S --needed "${MISSING_DEPS[@]}"
    elif command -v paru &> /dev/null; then
        echo -e "${GREEN}Syncing dependencies via paru...${NC}"
        paru -S --needed "${MISSING_DEPS[@]}"
    else
        echo -e "${YELLOW}No AUR helper found. Attempting install via pacman...${NC}"
        sudo pacman -S --needed "${MISSING_DEPS[@]}"
    fi
else
    echo -e "${GREEN}✅ All core system dependencies are already installed.${NC}"
fi

# 3. System Binary Setup
echo -e "${CYAN}⚙️  Deploying system binary and layout configuration templates...${NC}"
sudo cp ./audio_record_hud.sh /usr/bin/hypr-audio-hud
sudo chmod +x /usr/bin/hypr-audio-hud

sudo mkdir -p /usr/share/hypr-audio-hud
sudo cp ./hyprland-hud-rules.lua /usr/share/hypr-audio-hud/hyprland-hud-rules.lua

# 4. Final instruction block
echo ""
echo -e "${GREEN}======================================================${NC}"
echo -e "${GREEN}🎉 hypr-audio-hud has been successfully installed!${NC}"
echo -e "${GREEN}======================================================${NC}"
echo -e "${YELLOW}To complete configuration, append the rules template into your setup:${NC}"
echo -e "cat /usr/share/hypr-audio-hud/hyprland-hud-rules.lua >> ~/.config/hypr/hyprland/rules.lua"
echo ""
echo -e "${CYAN}Map your hotkey (SUPER + FN + R) inside your keybindings file.${NC}"
echo -e "${CYAN}Then execute 'hyprctl reload' to activate your new interactive HUD.${NC}"
