extends Node

var selected_job




func _job_entered(body:Node, job: int) -> void:
	if body.name == Server.local_player_id:
		selected_job = job
