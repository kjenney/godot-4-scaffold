class_name Pawn
extends Node2D

signal moved
signal interacted
signal dialogue_started

@export var combat_actor: PackedScene
@export var lost: bool = false
@export var is_dialogue_target: bool = false

var current_cell: Cell = null
var grid: Grid = null

func _ready() -> void:
	if grid == null:
		grid = get_tree().get_first_node_in_group("grid")

func set_position_on_grid(pos: Vector2) -> void:
	var cell := grid.get_cell_at(pos)
	if cell and cell.cell_type != Cell.CellType.SOLID and not cell.occupied:
		current_cell = cell
		cell.occupied = true
		position = pos
		moved.emit()

func move_to(new_pos: Vector2) -> bool:
	if current_cell:
		current_cell.occupied = false
	if not grid.is_solid(new_pos) and not grid.is_occupied(new_pos):
		set_position_on_grid(new_pos)
		moved.emit()
		return true
	return false

func interact() -> void:
	interacted.emit()
	if is_dialogue_target:
		dialogue_started.emit()
