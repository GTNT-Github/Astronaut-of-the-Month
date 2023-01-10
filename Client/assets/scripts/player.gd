extends KinematicBody2D
export var speed = 250
var faceLeft: bool = true

onready var player_label = $Name
onready var camera = $Camera

func _ready() -> void:
#	player_label.set_as_toplevel(true)
	set_player_name()

func _physics_process(_delta: float) -> void:
	
	if is_network_master():
		camera.current = true
#		player_label.rect_position = Vector2(position.x-495, position.y -60)
		var velocity: Dictionary = getInput()
		move_and_slide(velocity["velocity"]*speed)
		
		rpc_unreliable_id(1, "update_player", global_transform, velocity["animation"])
		
remote func update_remote_player(transform,animation):
	if not is_network_master():
		global_transform = transform
		$Sprite.play(animation)
#		player_label.rect_position = Vector2(position.x-495,position.y-60)

func getInput() -> Dictionary:
	var animatedSprite = $Sprite
	var velocity: Vector2 = Vector2.ZERO
	var animation: String = "idle"
	
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
		animation = "walk"
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
		animation = "walk"
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
		animation = "walk"
		faceLeft = false
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
		animation = "walk"
		faceLeft = true
		
	if animation != animatedSprite.animation:
		animatedSprite.play(animation)
		animatedSprite.flip_h = faceLeft
	return {"velocity": velocity,"animation":animation}

func set_player_name():
	player_label.text = Server.players[int(name)]["Player_name"]
