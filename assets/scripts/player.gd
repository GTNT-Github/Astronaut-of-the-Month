extends CharacterBody2D
@export var speed = 250
var faceLeft: bool = true
@onready var syncronizer = $MultiplayerSynchronizer

func _ready():
	syncronizer.set_multiplayer_authority(str(name).to_int())
	$Camera2D.current = syncronizer.is_multiplayer_authority()
	
func _process(_delta: float) -> void:
	if syncronizer.is_multiplayer_authority():
		var velocity: Vector2 = getInput()
		set_velocity(velocity*speed)
		move_and_slide()
		syncronizer.position = position
	$/root/Game/UI/FPS.text = str("FPS: ",Engine.get_frames_per_second())
func getInput() -> Vector2:
	var animatedSprite = $Sprite
	var velocity: Vector2 = Vector2.ZERO
	var animation: String = "idle"
	
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		animation = "walk"
	if Input.is_action_pressed("down"):
		velocity.y += 1
		animation = "walk"
	if Input.is_action_pressed("right"):
		velocity.x += 1
		animation = "walk"
		faceLeft = false
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		animation = "walk"
		faceLeft = true
		
	if animation != animatedSprite.animation:
		animatedSprite.play(animation)
		animatedSprite.flip_h = faceLeft
	return velocity
