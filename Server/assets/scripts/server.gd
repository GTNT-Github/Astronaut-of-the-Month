extends Node

var network = NetworkedMultiplayerENet.new()
var port = 3234
var max_players = 4

var data = {}
var players = {}

func _ready():
	start_server()


func start_server():
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	network.connect("peer_disconnected", self, "_player_disconnected")


func _player_disconnected(player_id):
	var player_lobby = players[player_id]
	var player_name = data[player_lobby]["players"][player_id]["Player_name"]
	data[player_lobby]["players"].erase(player_id)

	print(data[player_lobby]["players"].size())
	if data[player_lobby]["players"].size() == 0:
		data.erase(player_lobby)
		print(69420)
		get_node("/root/"+player_lobby).queue_free()
		return
	
	if Server.data[player_lobby]["active_game"]:
		get_node("/root/"+player_lobby).remove_player(player_lobby, player_id, player_name)
	
	update_player_list(player_lobby, player_id)


remote func send_player_info(lobby_id, id, player_data):
	if !data.has(lobby_id):
		create_lobby(lobby_id,id)
		
	#Set player data
	data[lobby_id]["players"][id] = player_data
	players[id] = lobby_id
	
	update_player_list(lobby_id, id)


func update_player_list(lobby_id, id):
	#Update client player list
	for i in data[lobby_id]["players"]:
		rset_id(i,"players", data[lobby_id]["players"])
		
	#Update client waiting room
	for i in data[lobby_id]["players"]:
		rpc_id(i,"update_waiting_room")


remote func load_world(lobby_id):
	#Update ready players
	data[lobby_id]["ready_players"] += 1
	
	#check if all players are ready
	if data[lobby_id]["players"].size() > 1 and data[lobby_id]["ready_players"] >= data[lobby_id]["players"].size():
		
		#Start client worlds
		for i in data[lobby_id]["players"]:
			rpc_id(i,"start_game")
			
		#Start server world
		var world = preload("res://assets/scenes/world.tscn").instance()
		world.name = lobby_id
		get_tree().get_root().add_child(world)


func create_lobby(lobby_id,host_id):
	data[lobby_id] = {"players":{},"ready_players":0,"host":host_id,"active_game":false}
