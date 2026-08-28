extends Node2D

# A minimal "Hello World" example — a label and a button.

var click_count: int = 0

func _ready() -> void:
	var button = $VBoxContainer/Button
	button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	click_count += 1
	$VBoxContainer/Label.text = "Hello, Godot! (clicked %d)" % click_count
