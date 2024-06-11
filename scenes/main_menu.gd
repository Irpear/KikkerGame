extends Node


@onready var score_label = get_node("Label")

func _ready():
	var save_file = FileAccess.open("user://save.data", FileAccess.READ)
	if save_file != null:
		score_label.text = save_file.get_as_text()
	else:
		print("Kan save file niet openen.")



func _on_StartButton_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
