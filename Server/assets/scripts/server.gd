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
		if Server.data[player_lobby]["active_game"]:
			get_node("/root/"+player_lobby).queue_free()
		data.erase(player_lobby)
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


remote func load_world(lobby_id, id):
	
	#check if all players are ready
	if data[lobby_id]["host"]==id:
		
		#Start client worlds
		for i in data[lobby_id]["players"]:
			rpc_id(i,"start_game", lobby_id)
			
#		var timer = Timer.new()
#		timer.wait_time = 1
#		timer.name = lobby_id+"Timer"
#		add_child(timer)
#		timer.start()
#		for n in 3:
#			yield(timer,"timeout")
#			print(lobby_id+" stwarts in "+str(3-n)+" seconds!")
#			print(n)
#			if n == 2:
#				timer.queue_free()
		
		#Start server world
		var world = preload("res://assets/scenes/world.tscn").instance()
		world.name = lobby_id
		get_tree().get_root().add_child(world)


func create_lobby(lobby_id,host_id):
	print(lobby_id)
	data[lobby_id] = {"players":{},"host":host_id,"active_game":false}
