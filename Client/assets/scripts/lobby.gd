extends Control

onready var player_name = $TitleScreen/Name
onready var selected_lobby = $TitleScreen/JoinBtn/LobbyLabel
onready var lobby = $TitleScreen
onready var waiting_room = $WaitingRoom


func _ready() -> void:
	player_name.text = Save.save_data["Player_name"]


func _on_JoinBtn_pressed():
	Server.lobby_id = selected_lobby.text
	Server._connect_to_server()
	show_waiting_room(false)


func _on_NameTextBox_text_changed(new_text):
	Save.save_data["Player_name"] = player_name.text
	Save.save_game()


func show_waiting_room(host):
	lobby.visible = false
	waiting_room.visible = true
	$WaitingRoom/CenterContainer/VBoxContainer/StartBtn.visible = host


func _on_StartBtn_pressed():
	Server.load_game()


func _on_CreateBtn_pressed():
	Server.lobby_id = generate_id(6)
	Server._connect_to_server()
	show_waiting_room(true)


func generate_id(length):
	var chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890'
	var word: String
	var n_char = len(chars)
	for i in range(length):
		randomize()
		word += chars[randi()%n_char]
	return word
