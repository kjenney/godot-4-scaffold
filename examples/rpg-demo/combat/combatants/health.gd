extends Node

signal dead
signal health_changed(life: float)

@export var life: float = 10
@export var max_life: float = 10
@export var base_armor: float = 0

var armor: float = 0

func _ready():
	armor = base_armor

func take_damage(damage: float) -> void:
	life -= damage - armor
	if life <= 0:
		dead.emit()
	else:
		health_changed.emit(life)

func heal(amount: float) -> void:
	life += amount
	life = clamp(life, 0, max_life)
	health_changed.emit(life)
