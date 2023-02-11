extends Node
class_name Jobs

var selected_job

var sounds = {
	"flip_breaker": preload("res://assets/sounds/flip_breaker.wav"),
	"load_task": preload("res://assets/sounds/load_task.wav"),
	"task_complete": preload("res://assets/sounds/task_complete.wav"),
	"input_waypoint": preload("res://assets/sounds/input_waypoint.wav")
}


func play_sound(sound):
	var soundNode = AudioStreamPlayer.new()
	soundNode.stream = sounds[sound]
	add_child(soundNode)
	soundNode.play()
	yield(soundNode,"finished")


func _job_entered(body:Node, job: int) -> void:
	if body.name == Server.local_player_id:
		selected_job = job


func open_task():
	var tween = Tween.new()
	tween.interpolate_property(self, "rect_position", Vector2(-640,180),Vector2(320,180),.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	add_child(tween)
	tween.start()
	play_sound("load_task")


func close_task():
	var tween = Tween.new()
	tween.interpolate_property(self, "rect_position", Vector2(320,180),Vector2(-640,180),.4,Tween.TRANS_LINEAR,Tween.EASE_IN)
	add_child(tween)
	tween.start()
	play_sound("task_complete")
