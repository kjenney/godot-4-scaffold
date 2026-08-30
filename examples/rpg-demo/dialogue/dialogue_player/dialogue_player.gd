extends Node

signal dialogue_started
signal dialogue_finished

@export_file("*.json") var dialogue_file: String
var dialogue_keys: Array = []
var dialogue_name: String = ""
var current: int = 0
var dialogue_text: String = ""

@onready var dialogue_ui: Control = $"../DialogueUI"

func start_dialogue() -> void:
	dialogue_started.emit()
	current = 0
	index_dialogue()
	dialogue_text = dialogue_keys[current].text
	dialogue_name = dialogue_keys[current].name

func next_dialogue() -> void:
	current += 1
	if current == dialogue_keys.size():
		dialogue_finished.emit()
		return
	dialogue_text = dialogue_keys[current].text
	dialogue_name = dialogue_keys[current].name

func index_dialogue() -> void:
	var dialogue: Dictionary = load_dialogue(dialogue_file)
	dialogue_keys.clear()
	for key: String in dialogue:
		dialogue_keys.append(dialogue[key])

func load_dialogue(file_path: String) -> Dictionary:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if file:
		var test_json_conv := JSON.new()
		test_json_conv.parse(file.get_as_text())
		var result: Dictionary = test_json_conv.data as Dictionary
		return result
	return {}

func show_dialogue(dialogue_data: Dictionary, keys: Array) -> void:
	var key: String = keys[0]
	var entry: Dictionary = dialogue_data[key]
	dialogue_ui.show_dialogue(entry.name, entry.text)
