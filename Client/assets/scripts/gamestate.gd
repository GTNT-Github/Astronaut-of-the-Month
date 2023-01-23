extends Node2D

const PLAYER = preload("res://assets/scenes/player.tscn")

onready var player_spawn = $PlayerSpawn
onready var players = $Players

var active_game = false

func _ready() -> void:
	rpc_id(1, "spawn_players", Server.lobby_id, Server.local_player_id)


remote func spawn_player(id):
	var player = PLAYER.instance()
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
	var announcement_label = Label.new()
	announcement_label.text = announcement
	announcement_label.add_color_override("font_color", Color("c20000"))
	announcement_label.add_font_override("font", load("res://assets/fonts/defaultFont.tres"))
	$UI/announcements.add_child(announcement_label)
	
	var timer = Timer.new()
	timer.wait_time = 5
	timer.autostart = true
	add_child(timer)
	yield(timer,"timeout")
	
	var tween = Tween.new()
	tween.interpolate_property(announcement_label,"modulate",Color("ffffff"),Color("00ffffff"),1,Tween.TRANS_LINEAR,Tween.EASE_IN_OUT)
	add_child(tween)
	tween.start()
	yield(tween,"tween_completed")
	
	announcement_label.queue_free()
	timer.queue_free()
	tween.queue_free()
