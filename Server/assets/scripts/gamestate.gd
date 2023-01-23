extends Node2D

const PLAYER = preload("res://assets/scenes/player.tscn")

onready var players = $Players


remote func spawn_players(lobby_id, id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	for i in Server.data[lobby_id]["players"]:
		rpc_id(i,"spawn_player",id)

