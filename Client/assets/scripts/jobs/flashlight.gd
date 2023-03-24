extends Jobs

var dead_battery = true
var index = 4

func _ready() -> void:
	open_task()


func _dead_battery_clicked() -> void:
	$deadBattery.rect_position = Vector2(344,297)
	dead_battery = false
	play_sound("flip_breaker")
	
	




func _fresh_battery_clicked() -> void:
	if !dead_battery:
		$freshBattery.rect_position = Vector2(389,158)
		yield(play_sound("flip_breaker"),"completed")
		close_task()
