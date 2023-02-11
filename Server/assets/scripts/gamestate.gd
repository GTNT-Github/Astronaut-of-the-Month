extends Node2D

const PLAYER = preload("res://assets/scenes/player.tscn")

onready var players = $Players


remote func spawn_players(lobby_id, id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	for i in Server.data[lobby_id]["players"]:
		rpc_id(i,"spawn_player",id)
	Server.data[lobby_id]["active_game"] = true


func remove_player(lobby_id, id, player_name):
	print(Server.data[lobby_id]["active_game"])
	if Server.data[lobby_id]["active_game"]:
		get_node("Players/"+str(id)).queue_free()
		for i in Server.data[lobby_id]["players"]:
			rpc_id(i,"remove_player",id, player_name)
