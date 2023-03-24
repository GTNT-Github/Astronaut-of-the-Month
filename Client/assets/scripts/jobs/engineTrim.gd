extends Jobs

var slider_values = ["H","V","H","V"]
var slider_goals = []
var completed_trims = 0
var index = 3


func _ready() -> void:
	set_trim()
	open_task()


func set_trim():
	
	#Randomization
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_system_time_msecs()

	for i in 4:
		if slider_values[i] == "H":
			var num = rng.randi_range(8,112-8)
			get_node("Engine"+str(i)+"/Correct").rect_position.x = num
			slider_goals.insert(i,num)
		elif slider_values[i] == "V":
			var num = rng.randi_range(8,85-8)
			get_node("Engine"+str(i)+"/Correct").rect_position.x = num
			slider_goals.insert(i,num)




func _dragged(value: float, node: int, max_val: int) -> void:
	var goal = slider_goals[node]
	if value <= goal+8 and value>=goal-8:
		print(goal,value)
		get_node("Engine"+str(node)).value = goal
		get_node("Engine"+str(node)+"/Correct").modulate.a = 1
	else:
		get_node("Engine"+str(node)+"/Correct").modulate.a = .22


func _value_set(value_changed: bool, node: int) -> void:
	var value = get_node("Engine"+str(node)).value
	if value_changed && value == slider_goals[node]:
		yield(play_sound("input_waypoint"),"completed")
		completed_trims += 1
		if completed_trims == 4:
			close_task()
