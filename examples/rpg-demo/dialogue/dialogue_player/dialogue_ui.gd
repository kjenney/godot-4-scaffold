extends Control

@onready var name_label: Label = $PanelContainer/VBoxContainer/NameLabel
@onready var text_label: Label = $PanelContainer/VBoxContainer/TextLabel

func show_dialogue(speaker_name: String, text: String) -> void:
	name_label.text = speaker_name
	text_label.text = text
	visible = true
