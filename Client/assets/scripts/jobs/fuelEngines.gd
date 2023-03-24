extends Jobs

var eng1 = 0
var eng2 = 0

var pressed = 0
var full = 0

var index = 5


func _ready() -> void:
	open_task()

func _button_up(eng: int) -> void:
	pressed = 0


func _button_down(eng: int) -> void:
	pressed = eng

func _process(delta: float) -> void:
	if pressed == 1 && eng1 <= 1:
		eng1 += .004
		$Fuel1.rect_scale.y = eng1
		checkFull(eng1)
	elif pressed == 2 && eng2 <= 1:
		eng2 += .004
		$Fuel2.rect_scale.y = eng2
		checkFull(eng2)

func checkFull(eng):
	if eng >= 1:
		full += 1
		yield(play_sound("input_waypoint"),"completed")
	
	if full == 2:
		close_task()
