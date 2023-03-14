extends Jobs

var flipped_breakers = 5
var breakers = [1,1,1,1,1]
var index = 0

func _ready() -> void:
	randomize_breakers()
	open_task()


func randomize_breakers():
	
	#Randomization
	var rng = RandomNumberGenerator.new()
	rng.seed = OS.get_system_time_msecs()
	flipped_breakers = 5
	
	#Set 3 random breakers
	for i in 3:
		var num = rng.randi_range(0,4)
		if breakers[num] == 1:
			flipped_breakers -= 1
		breakers[num] = 0
		get_node("Breakers/Breaker"+str(num)).modulate = Color("ffffff")


func breaker_flipped(breaker_num: int) -> void:
	
	#Is breaker is flipped
	if breakers[breaker_num] == 0:
		play_sound("flip_breaker")
		get_node("Breakers/Breaker"+str(breaker_num)).modulate = Color("2cff00")
		flipped_breakers += 1
		
		#Are all breakers flipped
		if flipped_breakers == 5:
			close_task()
