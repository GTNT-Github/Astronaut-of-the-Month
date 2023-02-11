extends Node

var network = WebSocketServer.new()
var port = 3234
var max_players = 4

var data = {}
var players = {}
var job_refrence = ["Electrician","Janitor","Operator","Repairman","Cook"]
var job_assignements = {
	0:[0],
	1:[1],
	2:[2],
	3:[3],
	4:[4]}


func _ready():
	start_server()


func start_server():
	network.listen(port, PoolStringArray(), true)
	get_tree().set_network_peer(network)
	network.connect("peer_disconnected", self, "_player_disconnected")


func _player_disconnected(player_id):
	#Remove player
	var player_lobby = players[player_id]
	var player_name = data[player_lobby]["players"][player_id]["Player_name"]
	data[player_lobby]["players"].erase(player_id)

	#Delete lobby if empty
	if data[player_lobby]["players"].size() == 0:
		if Server.data[player_lobby]["active_game"]:
			get_node("/root/"+player_lobby).queue_free()
		data.erase(player_lobby)
		return
	
	#If in a game, remove player
	if Server.data[player_lobby]["active_game"]:
		get_node("/root/"+player_lobby).remove_player(player_lobby, player_id, player_name)
	
	update_player_list(player_lobby)


remote func send_player_info(lobby_id, id, player_data):
	#Create lobby if doesn't exist
	if !data.has(lobby_id):
		create_lobby(lobby_id,id)
	
	#Get jobs
	var free_jobs = data[lobby_id]["free_jobs"]
	
	#Select next available job
	if !free_jobs.has(player_data["Job"]):
		var next_job = free_jobs.keys()[0]
		player_data["Job"] = next_job
		
	#Set unavailable jobs
	data[lobby_id]["free_jobs"].erase(player_data["Job"])
	rset_id(id, "player_data", player_data)
	
	#Set player data
	data[lobby_id]["players"][id] = player_data
	players[id] = lobby_id
	
	update_player_list(lobby_id)


func update_player_list(lobby_id, old_job=null):
	#Remove players old job
	if old_job != null:
		for i in data[lobby_id]["players"]:
			rpc_id(i,"update_old_job", old_job)
	
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
			var player_data = data[lobby_id]["players"][i]
			player_data["jobs"] = job_assignements[player_data["Job"]]
			rset_id(i,"player_data",data[lobby_id]["players"][i])
			
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
	update_player_list(lobby_id, old_job)
