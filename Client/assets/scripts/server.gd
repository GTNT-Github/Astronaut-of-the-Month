extends Node

const DEFAULT_IP = "gtntstuff.com"
const LOCAL_IP = "localhost"
const DEFAULT_PORT = 3234

var network =  WebSocketClient.new()
var url = "ws://" + str(DEFAULT_IP) + ":" + str(DEFAULT_PORT)
var local_player_id = 0
var player_instances = {}

var jobs = [
	preload("res://assets/scenes/jobs/circuitBreakers.tscn"),
	preload("res://assets/scenes/jobs/temperature.tscn"),
	preload("res://assets/scenes/jobs/engineTrim.tscn"),
	preload("res://assets/scenes/jobs/fuelEngines.tscn"),
	preload("res://assets/scenes/jobs/chartCourse.tscn"),
]

sync var players = {}
sync var player_data = {}
sync var lobby_id = ""


func _connect_to_server():
#	network.verify_ssl = false
	print(1)
	get_tree().connect("connected_to_server", self, "_connected_ok")
	network.connect_to_url(url, PoolStringArray(), true)
	get_tree().set_network_peer(network)
	print(2)


func _connected_ok():
	print(3)
	register_player()
	rpc_id(1, "send_player_info", lobby_id, local_player_id, player_data)


func register_player():
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data


#tell server if job changed
func update_job(old_job):
	rpc_id(1,"update_job",Server.lobby_id, Server.local_player_id, Server.player_data, old_job)


sync func update_waiting_room():
	get_tree().call_group("WaitingRoom", "refresh_players", players)


#Tell server to load wpr;d
func load_game():
	rpc_id(1, "load_world", lobby_id, Server.local_player_id)


#Create client world
sync func start_game(id): 
	var world = preload("res://assets/scenes/world.tscn").instance()
	world.name = lobby_id
	get_tree().get_root().add_child(world)
	get_tree().get_root().get_node("Lobby").queue_free()

#Clear old job from waiting room
remote func update_old_job(old_job):
	get_tree().call_group("WaitingRoom", "update_old_job", old_job)
