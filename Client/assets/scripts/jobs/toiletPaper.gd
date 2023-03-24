extends Jobs

var dead_battery = true
var index = 8
func _ready() -> void:
	open_task()


func _dead_battery_clicked() -> void:
	$deadBattery.rect_position = Vector2(30,129)
	dead_battery = false
	play_sound("flip_breaker")
	
	




func _fresh_battery_clicked() -> void:
	if !dead_battery:
		$freshBattery.rect_position = Vector2(235,129)
		yield(play_sound("flip_breaker"),"completed")
		close_task()
