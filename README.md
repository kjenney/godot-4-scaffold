# Godot 4 CLI Scaffold

A minimal Godot 4.x project scaffolded entirely from the CLI — no Godot editor GUI required. Includes a CI/CD pipeline using GitHub Actions + [godot-ci](https://github.com/marketplace/actions/godot-ci).

## Project structure

```
godot-4-scaffold/
├── .github/workflows/
│   ├── godot-ci.yml          # Full CI: lint + export (Win/Linux/Web/Mac)
│   └── lint-only.yml         # Lightweight lint-only workflow
├── assets/
│   └── icon.png              # Placeholder — replace with your icon
├── source/
│   ├── main.tscn             # Entry point scene (Node2D)
│   └── main.gd               # Entry point script (loads main.tscn)
├── project.godot             # Project config (created from CLI)
├── .gitignore
└── README.md
```

## How to create a project from CLI only

```bash
# 1. Create directory
mkdir mygame && cd mygame

# 2. Create project.godot (minimal — the engine auto-fills missing fields)
cat > project.godot << 'EOF'
; Engine configuration file.
; It's best edited using the editor UI and not directly,
; since the parameters that go here are not all obvious.
;
; Format:
;   [section] ; section goes between []
;   param=value ; assign values to parameters

config_version=5

[application]

config/name="My Game"
run/main_scene="res://source/main.tscn"
config/features=PackedStringArray("4.3")

[display]

window/size/viewport_width=1280
window/size/viewport_height=720
window/size/mode=1
EOF

# 3. Create source directory and main scene
mkdir -p source assets
cat > source/main.tscn << 'EOF'
[gd_scene load_steps=2 format=3 uid="uid://myuid001"]

[ext_resource type="Script" path="res://source/main.gd" id="1_main"]

[node name="Main" type="Node2D"]
script = ExtResource("1_main")
EOF

cat > source/main.gd << 'EOF'
extends SceneTree

func _init():
	print("Hello from Godot 4!")
	var main_scene = load("res://source/main.tscn")
	var instance = main_scene.instantiate()
	add_child(instance)
EOF

# 4. Create .gitignore
cat > .gitignore << 'EOF'
# Godot editor settings
.editorconfig
*.remap
*.import
*.import.cfg

# Godot export presets
export-templates/
export_presets.cfg

# OS specific
.DS_Store
Thumbs.db
EOF
```

## Run the game

```bash
# From the project root:
godot --path .

# Or run a specific scene without opening the editor:
godot --path . --scene res://source/main.tscn

# Run a script outside a project:
godot -s path/to/script.gd

# Headless mode (no display, for CI):
godot --headless --path .
```

## Export from CLI

Export templates must be installed first (see below). Then:

```bash
# Linux
godot --headless --path . --export-release "Linux/X11" build/mygame.x86_64

# Windows
godot --headless --path . --export-release "Windows Desktop" build/mygame.exe

# Web
godot --headless --path . --export-release "Web" build/mygame/index.html

# macOS
godot --headless --path . --export-release "macOS" build/mygame.zip
```

## Install export templates (for CLI export)

```bash
GODOT_VERSION=4.3

# Download export templates
wget https://github.com/godotengine/godot/releases/download/${GODOT_VERSION}-stable/Godot_v${GODOT_VERSION}-stable_export_templates.tpz

# Extract to the export templates directory
mkdir -p ~/.local/share/godot/export_templates/
unzip -d ~/.local/share/godot/export_templates/ \
    Godot_v${GODOT_VERSION}-stable_export_templates.tpz
```

## CI/CD with GitHub Actions

This scaffold includes two workflow files:

### 1. `godot-ci.yml` — Full CI (lint + export)

Exports your game for Windows, Linux, Web, and macOS. The Web build is automatically deployed to GitHub Pages.

- Uses the [godot-ci](https://github.com/marketplace/actions/godot-ci) Docker image: `barichello/godot-ci:4.3`
- Runs on `ubuntu-24.04`
- Uploads all export artifacts via `actions/upload-artifact@v4`
- Deploys Web build to `gh-pages` branch via `JamesIves/github-pages-deploy-action`

### 2. `lint-only.yml` — Lightweight lint

Just runs GDScript linting — faster than a full export, good for PR checks.

- Uses `gdlint` via pip inside the godot-ci container
- Runs `godot --doctool` for API reference generation

### To use in your repo:

1. Push this scaffold (or just the `.github/workflows/` folder) to your repo
2. Make sure your `project.godot` is at the repo root (or set `PROJECT_PATH` env var)
3. Create export presets in the Godot editor for each target platform
4. The export preset **names must match** the strings used in the workflow (e.g. `"Windows Desktop"`, `"Linux/X11"`, `"Web"`, `"macOS"`)

## Creating export presets from CLI

You can create export presets programmatically by editing `export_presets.cfg`:

```bash
cat > export_presets.cfg << 'EOF'
[preset.0]

name="Windows Desktop"
platform="Windows Desktop"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="builds/windows/mygame.exe"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false

[preset.1]

name="Linux/X11"
platform="Linux/X11"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="builds/linux/mygame.x86_64"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false

[preset.2]

name="Web"
platform="Web"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="builds/web/index.html"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false

[preset.3]

name="macOS"
platform="macOS"
runnable=true
dedicated_server=false
custom_features=""
export_filter="all_resources"
include_filter=""
exclude_filter=""
export_path="builds/mac/mygame.zip"
encryption_include_filters=""
encryption_exclude_filters=""
encrypt_pck=false
encrypt_directory=false
EOF
```

## Resources

- [Godot Command Line Tutorial](https://docs.godotengine.org/en/latest/tutorials/editor/command_line_tutorial.html)
- [godot-ci GitHub Actions](https://github.com/marketplace/actions/godot-ci)
- [Godot Project Structure Template](https://github.com/SlayHorizon/godot-project-structure-template)
- [Godot Export Templates](https://godotengine.org/download/)
