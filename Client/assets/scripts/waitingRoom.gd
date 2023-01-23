extends TextureRect

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
	$CenterContainer/VBoxContainer/Copy/Label.text = "Copied!"
	$CenterContainer/VBoxContainer/Copy.disabled = true
	yield(get_tree().create_timer(3), "timeout")
	$CenterContainer/VBoxContainer/Copy/Label.text = "Copy Lobby ID"
	$CenterContainer/VBoxContainer/Copy.disabled = false

func start_countdown(lobby_id):
	var timer = Timer.new()
	timer.wait_time = 1
	timer.name = lobby_id+"Timer"
	add_child(timer)
	timer.start()
	for n in 3:
		yield(timer,"timeout")
		print(lobby_id+" starts in"+str(3-n)+" seconds!")
		if n == 2:
			timer.queue_free()
