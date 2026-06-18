# hypr-audio-hud 🎤✨

[![License: MIT](https://shields.io)](https://opensource.org)
[![Platform: Arch Linux](https://shields.io)](https://archlinux.org)
[![Window Manager: Hyprland 0.55+](https://shields.io)](https://hyprland.org)

An interactive, cyberpunk terminal audio recording HUD designed specifically for **Hyprland 0.55+ (Lua configuration)** and **Ghostty**. 

Instead of hiding invisibly in the background, `hypr-audio-hud` spawns a beautifully styled, interactive, floating overlay workspace. It allows you to select your audio capture source on the fly using `fzf`, records high-fidelity lossless audio via native PipeWire, and displays a live, real-time frequency equalizer powered by `cava`.

---

## ✨ Features

* **Dynamic Source Selection** – Interactive fuzzy-search menu (`fzf`) lists all active microphone and desktop audio streams dynamically.
* **Native PipeWire Architecture** – Utilizes `pw-record` for rock-solid, crash-free, system-wide `.wav` audio captures.
* **Live CAVA Engine** – Real-time terminal frequency bars mapped directly to the selected PipeWire Node ID.
* **Sleek HUD Aesthetics** – Borderless, heavily blurred, translucent Ghostty window featuring a vibrant custom neon palette.
* **Workspace Isolation** – Spawns cleanly on its own dedicated workspace to keep your primary workflows entirely clutter-free.

---

## 🛠️ Dependencies

Ensure you have the following core system utilities installed on your Arch Linux system:

```bash
sudo pacman -S ghostty cava fzf pipewire-utils wireplumber ncurses
```

---

## 📦 Installation

### AUR Installation (Recommended)

Install the package directly from the AUR using your preferred AUR helper:

```bash
yay -S hypr-audio-hud
```

### Manual Installation

Alternatively, clone this repository and place the executable manually into your system path:

```bash
sudo cp audio_record_hud.sh /usr/bin/hypr-audio-hud
sudo chmod +x /usr/bin/hypr-audio-hud
```

---

## ⚙️ Configuration

### 1. Hyprland Keybinding

Add the following keybinding block to your user-defined hotkeys configuration (e.g., `~/.config/hypr/hyprland/keybinds.lua` or your specific user overrides section) to toggle the HUD via `SUPER + CTRL + R`:

```lua
hl.bind("SUPER + CTRL + R", function()
    -- Check if the HUD script is already actively running
    local handle = io.popen("pgrep -f hypr-audio-hud")
    local result = handle:read("*a")
    handle:close()

    if result ~= "" then
        -- Gracefully interrupt the process to trigger the clean save sequence
        hl.exec_cmd("pkill -INT -f hypr-audio-hud")
    else
        -- Launch Ghostty with custom styling overrides and target the HUD binary
        hl.exec_cmd([[ghostty \
            --class=audio-recorder \
            --background-opacity=0.65 \
            --background-blur=true \
            --window-decoration=false \
            --window-padding-x=20 \
            --window-padding-y=20 \
            --palette=0=#1a1b26 \
            --palette=1=#f7768e \
            --palette=2=#73daca \
            --palette=3=#e0af68 \
            --palette=4=#7aa2f7 \
            --palette=5=#bb9af7 \
            --palette=6=#7dcfff \
            --palette=7=#c0caf5 \
            -e /usr/bin/hypr-audio-hud]])
    end
end)
```

### 2. Hyprland Window Rules (0.55+ Lua Table Syntax)

To guarantee the window floats, centers itself, and opens cleanly on its own isolated workspace, place this matching rule configuration into your layout rules file (e.g., `~/.config/hypr/hyprland/rules.lua`):

```lua
hl.window_rule({
    match = { class = "audio-recorder" },
    workspace = "9", 
    float = true,
    size = { 400, 230 },
    center = true,
    focus_on_activate = true
})
```

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for detailed terms.

---

*Maintained by DarkstarDevX. [dsdx.tech@gmail.com]*
