extends Node2D

const JOBS = [preload("res://assets/scenes/players/electrician.tscn"),
			  preload("res://assets/scenes/players/janitor.tscn"),
			  preload("res://assets/scenes/players/operator.tscn")]

onready var player_spawn = $PlayerSpawn
onready var players = $Players

var active_game = false
var open_job
	
sync var data = {}

var job_assignements = {
	0:"Chart course",
	1:"Circuit breakers",
	2:"Clean windows",
	3:"Engine trim",
	4:"Flashlight",
	5:"Fuel engines",
	6:"Mop the floor",
	7:"Set temperature",
	8:"Replace toilet paper"}

func _ready() -> void:
	
	#Ask server to spawn players
	rpc_id(1, "spawn_players", Server.lobby_id, Server.local_player_id)
	
	
	#Set personal jobs
	for i in Server.player_data["Jobs"]:
		var job_label = Label.new()
		job_label.text = job_assignements[i]
		job_label.add_font_override("font", load("res://assets/fonts/defaultFont.tres"))
		$UI/jobs.add_child(job_label)


remote func spawn_player(id,job):
	var player = JOBS[job].instance()
	player.name = str(id)
	players.add_child(player)
	player.set_network_master(id)
	player.position = player_spawn.position
	Server.player_instances[id] = player
	active_game = true


remote func remove_player(id, player_name):
	announce(player_name+" left the game")
	if active_game:
		get_node("Players/"+str(id)).queue_free()


func announce(announcement):
	
	#Create announcement text
	var announcement_label = Label.new()
	announcement_label.text = announcement
	announcement_label.add_color_override("font_color", Color("c20000"))
	announcement_label.add_font_override("font", load("res://assets/fonts/defaultFont.tres"))
	$UI/announcements.add_child(announcement_label)
	
	#Announcement timer
	var timer = Timer.new()
	timer.wait_time = 5
	timer.autostart = true
	add_child(timer)
	yield(timer,"timeout")
	
	#Fade out announcement
	var tween = Tween.new()
	tween.interpolate_property(announcement_label,"modulate",Color("ffffff"),Color("00ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	add_child(tween)
	tween.start()
	yield(tween,"tween_completed")
	
	#Clear nodes
	announcement_label.queue_free()
	timer.queue_free()
	tween.queue_free()


func complete_job(job):
	rpc_id(1, "complete_job", Server.lobby_id, job)


func _sabotage() -> void:
	print(1)
	var job = $Jobs.sabotage_job
	rpc_id(1, "sabotage_job", Server.lobby_id, job)
	print(2)
