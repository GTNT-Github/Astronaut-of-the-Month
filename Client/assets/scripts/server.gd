extends Node

const DEFAULT_IP = "172.17.0.1"
const DEFAULT_PORT = 3234

var network = NetworkedMultiplayerENet.new()
var local_player_id = 0
var player_instances = {}

sync var players = {}
sync var player_data = {}
sync var lobby_id = ""


func _connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(DEFAULT_IP, DEFAULT_PORT)
	get_tree().set_network_peer(network)


func _connected_ok():
	register_player()
	rpc_id(1, "send_player_info", lobby_id, local_player_id, player_data)


func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data

func update_job(old_job):
	rpc_id(1,"update_job",Server.lobby_id, Server.local_player_id, Server.player_data, old_job)

sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)


func load_game():
	rpc_id(1, "load_world", lobby_id, Server.local_player_id)


sync func start_game(): 
#	get_tree().call_group("WaitingRoom", "start_countdown", lobby_id)
	
#	yield(get_tree().create_timer(4), "timeout")
	var world = preload("res://assets/scenes/world.tscn").instance()
	world.name = lobby_id
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").queue_free()


remote func update_old_job(old_job):
	get_tree().call_group("WaitingRoom", "update_old_job", old_job)
