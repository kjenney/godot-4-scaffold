extends SceneTree

# Entry point script.
# Perform any setup before loading the actual game or main menu.
func _init():
	print("Godot 4 Scaffold — hello!")
	# Load the main scene (menu or game)
	var main_scene = load("res://source/main.tscn")
	var instance = main_scene.instantiate()
	add_child(instance)
