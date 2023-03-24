extends Jobs

var sponge = false
var overlap = false
var time = 0
var index = 6
func _ready() -> void:
	open_task()


func _process(delta: float) -> void:
	if sponge:
		$TextureButton.rect_position = get_viewport().get_mouse_position()-Vector2(320+32,170+16)
		if overlap:
			time += delta
			if time >= 3:
				overlap = false
				close_task()


func _sponge_down() -> void:
	sponge = true


func _sponge_up() -> void:
	sponge = false
	$TextureButton.rect_position = Vector2(64,148)


func _sponge_entered(area: Area2D) -> void:
	if area == $TextureButton/Area2D:
		overlap = true


func _sponge_exited(area: Area2D) -> void:
	if area == $TextureButton/Area2D:
		overlap = false
