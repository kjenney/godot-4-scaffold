extends Node2D

@onready var grid: Node2D = $Grid
@onready var player: Node2D = $Grid/Player
@onready var dialogue_ui: Node2D = $DialogueCanvas/DialogueUI
@onready var dialogue_player: Node2D = $DialogueCanvas/DialoguePlayer
@onready var console_label: Label = $DialogueCanvas/ConsoleLabel

# Simple NPC enemy pawn that triggers combat
@export var enemy_spawn_point: Vector2
var enemy: Node2D
var dialogue_active: bool = false

func _ready():
	# Show console message
	console_label.text = "welcome to the thunderdome"
	console_label.visible = true
	
	# Set up the grid
	var grid_script: Script = grid.get_script()
	if grid_script:
		grid_script.setup_grid()
	
	# Place some walls (solid cells) around the edges
	_setup_walls()
	
	# Place player
	var player_script: Script = player.get_script()
	if player_script:
		player_script.set_position_on_grid(Vector2(2 * Grid.CELL_SIZE + grid.grid_origin.x * Grid.CELL_SIZE, 2 * Grid.CELL_SIZE + grid.grid_origin.y * Grid.CELL_SIZE))
	
	# Place enemy
	_setup_enemy()
	
	# Connect interaction signal
	if player_script:
		player_script.interacted.connect(_on_player_interacted)

func _setup_walls():
	var grid_script: Script = grid.get_script()
	for x in range(Grid.GRID_WIDTH):
		grid_script.cells[0][x].cell_type = Cell.CellType.SOLID
		grid_script.cells[0][x].queue_redraw()
		grid_script.cells[Grid.GRID_HEIGHT-1][x].cell_type = Cell.CellType.SOLID
		grid_script.cells[Grid.GRID_HEIGHT-1][x].queue_redraw()
	for y in range(Grid.GRID_HEIGHT):
		grid_script.cells[y][0].cell_type = Cell.CellType.SOLID
		grid_script.cells[y][0].queue_redraw()
		grid_script.cells[y][Grid.GRID_WIDTH-1].cell_type = Cell.CellType.SOLID
		grid_script.cells[y][Grid.GRID_WIDTH-1].queue_redraw()

func _setup_enemy():
	var enemy_scene := preload("res://grid_movement/pawns/enemy.tscn")
	enemy = enemy_scene.instantiate()
	enemy.position = Vector2(8 * Grid.CELL_SIZE + grid.grid_origin.x * Grid.CELL_SIZE, 8 * Grid.CELL_SIZE + grid.grid_origin.y * Grid.CELL_SIZE)
	grid.add_child(enemy)
	
	var enemy_script: Script = enemy.get_script()
	if enemy_script:
		enemy_script.set_position_on_grid(enemy.position)
		enemy_script.is_dialogue_target = true

func _on_player_interacted():
	# Trigger enemy dialogue
	if enemy and not enemy.lost:
		_show_enemy_dialogue()

func _show_enemy_dialogue():
	# Show dialogue with enemy
	var dialogue_data: Dictionary = {
		"dialog_1": {"name": "OPPONENT", "text": "Hey, it's a good time to have a JRPG fight, right?"},
		"dialog_2": {"name": "OPPONENT", "text": "Let me introduce myself, I'm your OPPONENT."},
		"dialog_3": {"name": "OPPONENT", "text": "Enough talking. Let's fight!"},
	}
	_show_dialogue(dialogue_data, "OPPONENT")

func _show_dialogue(dialogue_data: Dictionary, speaker_name: String) -> void:
	var keys := dialogue_data.keys()
	dialogue_player.show_dialogue(dialogue_data, keys)
