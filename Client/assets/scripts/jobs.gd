extends Node
class_name Jobs

var selected_job
var sabotage_job
var sounds = {
	"flip_breaker": preload("res://assets/sounds/flip_breaker.wav"),
	"load_task": preload("res://assets/sounds/load_task.wav"),
	"task_complete": preload("res://assets/sounds/task_complete.wav"),
	"input_waypoint": preload("res://assets/sounds/input_waypoint.wav"),
	"clean_windows": preload("res://assets/sounds/clean_windows.wav")
}



func play_sound(sound):
	var soundNode = AudioStreamPlayer.new()
	soundNode.stream = sounds[sound]
	add_child(soundNode)
	soundNode.play()
	
	yield(soundNode,"finished")


func _job_entered(body:Node, job: int) -> void:
	#Check if player is own
	if int(body.get_parent().name) == Server.local_player_id && Server.player_data["Jobs"].has(job):
		selected_job = job
	if int(body.get_parent().name) == Server.local_player_id && get_parent().data[Server.lobby_id]["completed_jobs"].has(job) && !Server.player_data["StartingJobs"].has(job):
		get_parent().get_node("UI/Sabotage").disabled = false
		sabotage_job = job
		

func _job_exited(body:Node, job: int) -> void:
	selected_job = null
	get_parent().get_node("UI/Sabotage").disabled = true
	sabotage_job = null
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") && selected_job != null && !get_parent().open_job:
		var job = Server.jobs[selected_job].instance()
		get_parent().get_node("UI").add_child(job)
		get_parent().open_job = selected_job
		selected_job = null


func open_task():
	#Slide task in
	var tween = Tween.new()
	tween.interpolate_property(self, "rect_position", Vector2(-640,180),Vector2(320,180),.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	add_child(tween)
	tween.start()
	
	play_sound("load_task")


func close_task():
	#Slide task out
	var tween = Tween.new()
	tween.interpolate_property(self, "rect_position", Vector2(320,180),Vector2(-640,180),.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	add_child(tween)
	tween.start()
	
	#Remove Job
	var job_index = Server.player_data["Jobs"].find(get_parent().get_parent().open_job)
	Server.player_data["Jobs"][job_index] = "DONE"
	get_parent().get_parent().get_node("UI/jobs").get_children()[job_index].modulate = Color(0,1,0)
	get_parent().get_parent().open_job = null
	get_parent().get_parent().complete_job(self.index)
	play_sound("task_complete")
	yield(tween,"tween_completed")
	
	queue_free()
