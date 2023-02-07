extends Jobs

var flipped_breakers = 5
var breakers = [1,1,1,1,1]


func _ready() -> void:
	var tween = Tween.new()
	tween.interpolate_property(self, "rect_position", Vector2(-640,180),Vector2(320,180),.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	add_child(tween)
	tween.start()
	play_sound("load_task")
	randomize_breakers()


func randomize_breakers():
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_system_time_msecs()
	flipped_breakers = 5
	for i in 3:
		var num = rng.randi_range(0,4)
		if breakers[num] == 1:
			flipped_breakers -= 1
		breakers[num] = 0
		get_node("Breakers/Breaker"+str(num)).modulate = Color("ffffff")


func breaker_flipped(breaker_num: int) -> void:
	if breakers[breaker_num] == 0:
		play_sound("flip_breaker")
		get_node("Breakers/Breaker"+str(breaker_num)).modulate = Color("2cff00")
		flipped_breakers += 1
		if flipped_breakers == 5:
			play_sound("task_complete")
			var tween = Tween.new()
			tween.interpolate_property(self, "rect_position", Vector2(320,180),Vector2(-640,180),.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
			add_child(tween)
			tween.start()
