class_name Grid
extends Node2D

signal cell_activated(cell: Cell)

const CELL_SIZE := 64
const GRID_WIDTH := 20
const GRID_HEIGHT := 12

@export var grid_origin: Vector2i = Vector2i(0, 0)

var cells: Array[Array] = []

func setup_grid() -> void:
	for i in range(cells.size()):
		for j in range(cells[i].size()):
			cells[i][j].queue_free()
	cells.clear()

	var cell_scene := preload("res://grid_movement/grid/cell.tscn")

	for y in range(GRID_HEIGHT):
		var row: Array[Cell] = []
		for x in range(GRID_WIDTH):
			var cell := cell_scene.instantiate() as Cell
			cell.position = Vector2i(x * CELL_SIZE, y * CELL_SIZE) + grid_origin * CELL_SIZE
			row.append(cell)
			add_child(cell)
		cells.append(row)

func get_cell_at(pos: Vector2) -> Cell:
	var x := (pos.x - grid_origin.x * CELL_SIZE) / CELL_SIZE
	var y := (pos.y - grid_origin.y * CELL_SIZE) / CELL_SIZE
	if x < 0 or x >= GRID_WIDTH or y < 0 or y >= GRID_HEIGHT:
		return null
	return cells[int(y)][int(x)]

func is_solid(pos: Vector2) -> bool:
	var cell := get_cell_at(pos)
	if cell == null:
		return true
	return cell.cell_type == Cell.CellType.SOLID

func is_occupied(pos: Vector2) -> bool:
	var cell := get_cell_at(pos)
	if cell == null:
		return true
	return cell.occupied

func activate_cell(cell: Cell) -> void:
	cell_activated.emit(cell)
