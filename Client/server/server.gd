extends Node

const defaultIp = "127.0.0.1"
const defaultPort = 3234

var network = NetworkedMultiplayerENet.new()
var selectedIp
var selectPort

var localPlayerId = 0
sync var players = {}
sync var player

func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")
	
func _connected_to_server():
		get_tree().connect("connected_to_server", self, "_connected_ok")
		network.create_client(defaultIp, defaultPort)
		get_tree().set_network_peer(network)

func _player_connected(id):
	print("Player: "+str(id)+" Connected")

func _player_disconnected(id):
	print("Player: "+str(id)+" Disconnected")
	
func _connected_ok():
	print("Successfully connected to server")
	
func _conected_fail():
	print("Failed to connect")
	
func _server_disconnected():
	print("Server Disconnected")
