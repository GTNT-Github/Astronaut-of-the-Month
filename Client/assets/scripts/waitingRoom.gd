extends Popup

onready var player_list = $CenterContainer/VBoxContainer/ItemList
onready var id_label = $CenterContainer/VBoxContainer/ID

func _ready():
	player_list.clear()


func refresh_players(players):
	player_list.clear()
	for player_id in players:
		var player = players[player_id]["Player_name"]
		player_list.add_item(player, null, false)
	id_label.text = "Lobby ID: "+Server.lobby_id


func _on_Copy_pressed() -> void:
	OS.clipboard = Server.lobby_id
