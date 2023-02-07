extends Node
class_name Jobs

var selected_job

var sounds = {
	"flip_breaker": preload("res://assets/sounds/flip_breaker.wav"),
	"load_task": preload("res://assets/sounds/load_task.wav"),
	"task_complete": preload("res://assets/sounds/task_complete.wav"),
}

func play_sound(sound):
	var soundNode = AudioStreamPlayer.new()
	soundNode.stream = sounds[sound]
	add_child(soundNode)
	soundNode.play()

func _job_entered(body:Node, job: int) -> void:
	if body.name == Server.local_player_id:
		selected_job = job
