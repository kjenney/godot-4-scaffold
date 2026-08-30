# RPG Demo

A 2D grid-based role-playing game built from the **godot-4-scaffold** project template.

## What was built

This demo demonstrates the core systems of a JRPG-style game:

- **Grid-based exploration** — Walk around a tile map using arrow keys. Stand on a solid tile and press `Interact` to trigger events.
- **Dialogue system** — JSON-driven dialogue that shows character names and text in a dialogue box.
- **Turn-based combat** — Enter combat by interacting with an NPC. Fight using Attack, Defend, or Flee.
- **Victory/defeat dialogue** — After combat, a win or lose dialogue plays automatically.

## How it was built from the scaffold

The scaffold provides a clean project structure with CI/CD, export presets, and a minimal `main.tscn` entry point. To build this RPG demo, the following steps were taken:

### 1. Project structure
The scaffold's `source/main.tscn` was replaced with `game.tscn` as the main scene. The scaffold's `project.godot` was kept as-is (the `run/main_scene` path was updated to point to `res://game.tscn`).

### 2. Grid movement
Three new files were added under `grid_movement/`:
- `grid/cell.gd` — A single grid cell (empty, solid, door, or actor) with a `_draw()` method for rendering.
- `grid/grid.gd` — Manages the 20×12 tile grid, cell lookup, and movement validation.
- `pawns/pawn.gd` — Base class for player/enemy characters that handles grid positioning and interaction.
- `pawns/player.gd` — Player pawn with keyboard movement (arrow keys).
- `pawns/enemy.gd` — Enemy pawn that triggers dialogue when interacted with.
- `exploration.tscn` — The exploration scene with a grid, player, and dialogue canvas.

### 3. Combat system
Three new files were added under `combat/`:
- `combatants/health.gd` — Health component with damage, healing, and armor.
- `combatants/combatant.gd` — Base combatant class with attack/defend/flee actions.
- `combat/turn_queue.gd` — Turn-based queue that cycles through combatants.
- `combat/combat.gd` — Main combat scene that manages combatants, turn order, and win/lose logic.
- `interface/ui.gd` — Combat UI with Attack, Defend, and Flee buttons.
- `combat/combat.tscn` — Combat scene with layout and UI connections.
- `combatants/combatant.tscn` — Combatant prefab with Health node.

### 4. Dialogue system
Three new files were added under `dialogue/`:
- `dialogue_player/dialogue_player.gd` — Loads dialogue from JSON files and manages turn-by-turn dialogue advancement.
- `dialogue_player/dialogue_ui.gd` — Simple UI that shows speaker name and dialogue text.
- `dialogue/dialogue_data/*.json` — Dialogue data files (npc.json, player_won.json, player_lose.json).

### 5. Game orchestration
Two files tie everything together under the project root:
- `game.gd` — The main game script that handles transitions between exploration and combat, triggers combat when the player interacts with an enemy, and plays post-combat dialogue.
- `game.tscn` — The main scene with Combat and Exploration layers, an AnimationPlayer for fade transitions, and a Camera2D.

## Controls

- **Arrow keys** — Move around the grid
- **Interact** — Interact with NPCs and objects

## Notes

- The demo uses placeholder scenes — sprites and textures are not included. Replace `texture = null` in the scene files with your own assets.
- The grid is 20×12 tiles at 64px each, with walls around the perimeter.
- Combat starts automatically when the player interacts with the enemy NPC on the grid.
