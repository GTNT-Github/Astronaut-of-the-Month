extends KinematicBody2D
export var speed = 250
var faceLeft: bool = true

onready var player_label = $Name
onready var camera = $Camera


func _ready() -> void:
	set_player_name()


func _process(delta: float) -> void:
	#If player is own
	if is_network_master() && !get_parent().get_parent().open_job:
		
		#Set position
		$Camera.current = true
		var velocity: Dictionary = getInput()
		move_and_slide((velocity["velocity"]*speed).floor())
		
		#Update server
		rpc_unreliable_id(1, "update_player", Server.lobby_id, global_transform, velocity["animation"])


#Update other players
remote func update_remote_player(transform,animation):
	if not is_network_master():
		global_transform = transform
		$Sprite.play(animation)


#Player moving
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
