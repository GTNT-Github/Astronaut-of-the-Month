extends Node2D

var multiplayerPeer = ENetMultiplayerPeer.new()

const PORT = 9999
const ADDRESS = "localhost"

func start_server():
	$UI/Host.visible = false
	$UI/Join.visible = false
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
