extends Pawn

@export var move_speed: float = 300.0
@export var sprite: Texture2D
var target_position: Vector2
var anim_time: float = 0.0

func _ready() -> void:
	add_to_group("grid")
	target_position = position

func _process(delta: float) -> void:
	var direction := Vector2.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	if direction != Vector2.ZERO:
		var step := direction.normalized()
		var new_pos := position + step * move_speed * delta
		# Snap to grid
		var grid_x := (new_pos.x - grid.grid_origin.x * Grid.CELL_SIZE)
		var grid_y := (new_pos.y - grid.grid_origin.y * Grid.CELL_SIZE)
		var snapped_x: float = grid.grid_origin.x * Grid.CELL_SIZE + snapped(grid_x / Grid.CELL_SIZE, 1.0) * Grid.CELL_SIZE
		var snapped_y: float = grid.grid_origin.y * Grid.CELL_SIZE + snapped(grid_y / Grid.CELL_SIZE, 1.0) * Grid.CELL_SIZE

		if move_to(Vector2(snapped_x, snapped_y)):
			target_position = position

	if interaction_pressed():
		interact()

func interaction_pressed() -> bool:
	return Input.is_action_just_pressed("interact")
