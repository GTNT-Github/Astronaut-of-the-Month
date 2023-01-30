extends Node

var network = WebSocketServer.new()
var port = 3234
var max_players = 4

var data = {}
var players = {}
var job_refrence = ["Electrician","Janitor","Operator","Repairman","Cook"]


func _ready():
	start_server()


func start_server():

#	var crypto = Crypto.new()
#	var key = crypto.generate_rsa(4096)
#	var cert = crypto.generate_self_signed_certificate(key, "CN=gtntstuff.com,O=myorganisation,C=IT")
#	key.save("res://cloudKey.key")
#	cert.save("res://cloudCert.crt")
	
#	network.private_key = load("res://cloudKey.key")
#	network.ssl_certificate = load("res://cloudCert.crt")
	network.listen(port, PoolStringArray(), true)
	get_tree().set_network_peer(network)
	network.connect("peer_disconnected", self, "_player_disconnected")


func _player_disconnected(player_id):
	var player_lobby = players[player_id]
	var player_name = data[player_lobby]["players"][player_id]["Player_name"]
	data[player_lobby]["players"].erase(player_id)

	if data[player_lobby]["players"].size() == 0:
		if Server.data[player_lobby]["active_game"]:
			get_node("/root/"+player_lobby).queue_free()
		data.erase(player_lobby)
		return
	
	if Server.data[player_lobby]["active_game"]:
		get_node("/root/"+player_lobby).remove_player(player_lobby, player_id, player_name)
	
	update_player_list(player_lobby)


remote func send_player_info(lobby_id, id, player_data):
	if !data.has(lobby_id):
		create_lobby(lobby_id,id)
		
	var free_jobs = data[lobby_id]["free_jobs"]
	
	if !free_jobs.has(player_data["Job"]):
		var next_job = free_jobs.keys()[0]
		player_data["Job"] = next_job
		
	data[lobby_id]["free_jobs"].erase(player_data["Job"])
	rset_id(id, "player_data", player_data)
	#Set player data
	data[lobby_id]["players"][id] = player_data
	players[id] = lobby_id
	
	update_player_list(lobby_id)


func update_player_list(lobby_id, old_job=null):
	#Update client player list
	
	if old_job != null:
		for i in data[lobby_id]["players"]:
			rpc_id(i,"update_old_job", old_job)
	
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
		
		#Start server world
		var world = preload("res://assets/scenes/world.tscn").instance()
		world.name = lobby_id
		get_tree().get_root().add_child(world)


func create_lobby(lobby_id,host_id):
	data[lobby_id] = {"players":{},"host":host_id,"active_game":false,"free_jobs":{0:"Electrician",1:"Janitor",2:"Operator",3:"Repairman",4:"Cook"}}


remote func update_job(lobby_id, player_id, player_data, old_job):
	data[lobby_id]["players"][player_id] = player_data
	data[lobby_id]["free_jobs"].erase(player_data["Job"])
	data[lobby_id]["free_jobs"][old_job] = job_refrence[old_job]
	prints(3, old_job)
	update_player_list(lobby_id, old_job)
