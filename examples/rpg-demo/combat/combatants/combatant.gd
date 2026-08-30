extends Node

signal turn_finished

@export var damage: float = 2
@export var defense: float = 1

var active: bool = false:
	set = _set_active

@onready var health: Node = $Health

func _set_active(value: bool) -> void:
	active = value
	set_process(value)
	set_process_input(value)
	
	if not active:
		return
	if health.armor >= health.base_armor + defense:
		health.armor = health.base_armor

func attack(target: Node) -> void:
	target.health.take_damage(damage)
	turn_finished.emit()

func defend() -> void:
	health.armor += defense
	turn_finished.emit()

func flee() -> void:
	turn_finished.emit()
