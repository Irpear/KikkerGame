extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

signal coin_collected

func _on_body_entered(body):
	if body.name == "Player":
		emit_signal("coin_collected")
		print("Coin collected by player")
		queue_free()
		
