---
description: "Project-specific Copilot context for the Slay the Pyramid / Card Wars Godot game. Use this for understanding architecture, naming conventions, and interaction patterns while editing or extending the game."
tags:
  - godot
  - gdscript
  - game
  - card
  - pyramid
  - ui
---

# Slay the Pyramid / Card Wars Project Context

This repository is a Godot 4.5 card game built as a tactical solitaire roguelite. The main game logic is implemented in GDScript and scene composition is handled in `scenes/`.

## Key architecture

- `scenes/main.tscn` is the main game scene and contains the top-level UI, deck, pyramid, player hand, options, and game over screens.
- `scripts/main.gd` controls game state, startup flow, game initialization, reset, and game over behavior.
- `scripts/deck.gd` manages the draw pile, card instantiation, deck interaction, and pyramid dealing.
- `scripts/pyramid.gd` manages the pyramid board, card uncovering, win condition, and pyramid card state.
- `scripts/player_hand.gd` manages the active player card, hand slot, streaks, bonus UI, and combat resolution.
- `scripts/input_manager.gd` routes player input to deck draws and pyramid card selection.
- `scripts/cardDatabase.gd` holds card definitions used by deck and card creation.

## Important gameplay concepts

- The game is card-based: cards have attack values, face-up/face-down states, and can be in the pyramid or in the player hand.
- `streakBonuses` are tracked on the main game node and affect active card power during combat.
- Bonus UI is implemented through a separate `bonus` scene instance with `plusone` and `plustwo` child sprites.
- Level-up messages and bonus visibility are controlled from `player_hand.gd` and the main scene.

## Scene / node conventions

- Node paths are accessed with `$"../NodeName"` and `get_node("...")`.
- Root nodes in scenes are usually `Node2D`, with children such as `Sprite2D`, `Area2D`, and `CollisionShape2D`.
- `Deck`, `PlayerHand`, `Pyramid`, and `CardManager` are important runtime nodes in `main.tscn`.

## Assets and resources

- `assets/` contains textures, fonts, and imported image resources used by scenes.
- `scenes/card.tscn` is the card prefab used for drawn cards.
- `scenes/bonus.tscn` is the bonus indicator scene.

## Editing guidance

- When changing game behavior, update both scene structure and script references consistently.
- When modifying combat or streak logic, check `player_hand.gd`, `main.gd`, and `pyramid.gd` together.
- When adjusting UI elements, verify node names and paths in `main.tscn`.
- Avoid hardcoding scene node paths without confirming the actual node hierarchy in the `.tscn` files.

## Notes

- The game has been designed for desktop use with a focus on card-draw and pyramid-clearing mechanics.
- The player’s active card can gain attack power from streak bonuses, and game reset logic clears bonus UI.
- The `main.gd` `gameOver()` flow may receive a win flag to hide the bonus UI on victory.
