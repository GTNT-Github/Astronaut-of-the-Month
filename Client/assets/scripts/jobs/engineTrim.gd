extends Jobs

var slider_values = ["H","V","V","H"]
var slider_goals = []
var completed_trims = 0
func _ready() -> void:
	set_trim()
	open_task()


func set_trim():
	
	#Randomization
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_system_time_msecs()

	for i in 4:
		if slider_values[i] == "H":
			var num = rng.randi_range(32,184)
			get_node("Sliders/Engine"+str(i)+"/Correct").rect_position.x = num
			slider_goals.insert(i,num)
		elif slider_values[i] == "V":
			var num = rng.randi_range(32,256)
			get_node("Sliders/Engine"+str(i)+"/Correct").rect_position.y = 256-num
			slider_goals.insert(i,num)




func _dragged(value: float, node: int, max_val: int) -> void:
	var goal = slider_goals[node]
	if value <= goal+8 and value>=goal-8:
		get_node("Sliders/Engine"+str(node)).value = goal
		get_node("Sliders/Engine"+str(node)+"/Correct").modulate.a = 1
	else:
		get_node("Sliders/Engine"+str(node)+"/Correct").modulate.a = .22


func _value_set(value_changed: bool, node: int) -> void:
	var value = get_node("Sliders/Engine"+str(node)).value
	if value_changed && value == slider_goals[node]:
		yield(play_sound("input_waypoint"),"completed")
		completed_trims += 1
		if completed_trims == 4:
			close_task()
