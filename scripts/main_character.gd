extends CharacterBody2D


const SPEED = 400.0
const JUMP_VELOCITY = -900.0
@onready var sprite_2d = $Sprite2D
var last_on_floor_time = 0.0
var max_time_since_on_floor = 0.1

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coins_collected = 0

@export var total_coins = 3


@onready var coin_label = get_node("/root/Game/CanvasLayer/CoinLabel")
@onready var timer_label = get_node("/root/Game/CanvasLayer/Panel/Timer")

@export var score: String = ""

const FLOOR_SNAP_LENGTH = 0.5

func _physics_process(delta):

	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "running"
	else:
		sprite_2d.animation = "default"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jumping"

	# Handle Jump.
	if is_on_floor():
		last_on_floor_time = 0.0
	else:
		last_on_floor_time += delta 

	if Input.is_action_just_pressed("jump") and (is_on_floor() or last_on_floor_time < max_time_since_on_floor):
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, direction * SPEED, 0.3)
	else:
		velocity.x = move_toward(velocity.x, 0, 40)


	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	
	
	

var elapsed_time : float = 0.0

func _ready():
	set_process(true)
	Global.script_a_node = self
	for coin in get_tree().get_nodes_in_group("Coins"): 
		coin.connect("coin_collected", Callable(self, "_on_coin_collected"))
		print("Connecting coin signal")

func _process(delta):
	if coins_collected < total_coins:
		elapsed_time += delta
		
		var minutes = int(elapsed_time) / 60
		var seconds = int(elapsed_time) % 60
		var milliseconds = int((elapsed_time - int(elapsed_time)) * 1000)
		
		var time_text = str(minutes).pad_zeros(2) + ":" + str(seconds).pad_zeros(2) + "." + str(milliseconds).pad_zeros(3)
		timer_label.text = time_text
		score = time_text
	else:
		var save_file = FileAccess.open("user://save.data", FileAccess.WRITE)
		save_file.store_string(score)
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_coin_collected():
	coins_collected += 1
	coin_label.texture = load("res://assets/" + str(coins_collected) + "coin.png")
	print(coins_collected)

	
