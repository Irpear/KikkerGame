extends AnimatableBody2D


@onready var parent:Node2D = get_parent()

func _physics_process(_delta: float) -> void:
	global_position = parent.global_position
