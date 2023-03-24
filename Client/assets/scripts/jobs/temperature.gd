extends Jobs

var target
var temp
var index = 7

func _ready() -> void:
	set_tempature()
	open_task()


func set_tempature():
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_system_time_msecs()
	
	temp = rng.randi_range(50,80)
	$Temp.text = str(temp)+"°"
	
	target = rng.randi_range(50,80)
	target = rng.randi_range(50,80) if temp == target else target
	$Target.text = str(target)+"°"




func _increase_temp() -> void:
	if temp != target:
		temp += 1
		$Temp.text = str(temp)+"°"
		play_sound("flip_breaker")
		check_target()
		


func _decrease_temp() -> void:
	if temp != target:
		temp -= 1
		$Temp.text = str(temp)+"°"
		play_sound("flip_breaker")
		check_target()
		
		

func check_target():
	if temp == target:
		$Temp.add_color_override("font_color",Color(0,1,0))
		yield(play_sound("input_waypoint"),"completed")
		yield(get_tree().create_timer(.3), "timeout")
		close_task()
