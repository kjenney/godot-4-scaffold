class_name Cell
extends Node2D

enum CellType {
	EMPTY,
	SOLID,
	DOOR,
	ACTOR,
}

const CELL_SIZE := 64
const SOLID_COLOR := Color(0.3, 0.25, 0.2, 1)
const EMPTY_COLOR := Color(0.25, 0.3, 0.2, 1)

@export var cell_type: CellType = CellType.EMPTY
@export var tile: Texture2D

var occupied: bool = false

func _draw() -> void:
	if tile:
		draw_texture(tile, Vector2(0, 0))
	elif cell_type == CellType.SOLID:
		draw_rect(Rect2(0, 0, CELL_SIZE, CELL_SIZE), SOLID_COLOR)
	elif cell_type == CellType.EMPTY:
		draw_rect(Rect2(0, 0, CELL_SIZE, CELL_SIZE), EMPTY_COLOR)
