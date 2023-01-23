extends Node

const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 3234

var network = NetworkedMultiplayerENet.new()
var selected_IP
var selected_port

var local_player_id = 0
sync var players = {}
sync var player_data = {}
sync var lobby_id = ""


func _connect_to_server():
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.create_client(selected_IP, selected_port)
	get_tree().set_network_peer(network)


func _connected_ok():
	print("Successfully connected to server")
	register_player()
	rpc_id(1, "send_player_info", lobby_id, local_player_id, player_data)


func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data


sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)


func load_game():
	rpc_id(1, "load_world", lobby_id)


sync func start_game(): 
	var world = preload("res://assets/scenes/world.tscn").instance()
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").queue_free()
