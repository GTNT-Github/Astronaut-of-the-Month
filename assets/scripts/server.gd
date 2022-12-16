extends Node2D

var multiplayerPeer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "localhost"
var upnp
func start_server():
	$UI/Host.visible = false
	$UI/Join.visible = false
	upnp = UPNP.new()
	var discoverResult = upnp.discover()
	
	if discoverResult == UPNP.UPNP_RESULT_SUCCESS:
		if upnp.get_gateway() and upnp.get_gateway().is_valid_gateway():
			var mapResultTcp = upnp.add_port_mapping(9999,0,"godotUdp","TCP",0)
			var mapResultUdp = upnp.add_port_mapping(9999,0,"godotUdp","UDP",0)
			if not mapResultTcp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(9999,9999,"","TCP")
			if not mapResultUdp == UPNP.UPNP_RESULT_SUCCESS:
				upnp.add_port_mapping(9999,9999,"","UDP")
	
	var externalIP = upnp.query_external_address()
	
	multiplayerPeer.create_server(PORT)
	multiplayer.multiplayer_peer = multiplayerPeer
	multiplayerPeer.peer_connected.connect(func(id): addPlayerChar(id))
	$UI/UUID.text = str(multiplayerPeer.get_unique_id())
	addPlayerChar()

func join_server():
	$UI/Host.visible = false
	$UI/Join.visible = false
	multiplayerPeer.create_client(ADDRESS,PORT)
	multiplayer.multiplayer_peer = multiplayerPeer
	$UI/UUID.text = str(multiplayerPeer.get_unique_id())

func addPlayerChar(id=1):
	var char = preload("res://assets/scenes/Player.tscn").instantiate()
	char.name = str(id)
	$"/root/Game".add_child(char)


func _on_multiplayer_spawner_spawned(node):
	print(1)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST && UPNP:
		upnp.delete_port_mapping(9999,"UDP")
		upnp.delete_port_mapping(9999,"TCP")
