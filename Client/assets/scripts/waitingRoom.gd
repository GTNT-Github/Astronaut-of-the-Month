extends TextureRect

onready var item_list = $VBoxContainer/ItemList
onready var id_label = $VBoxContainer/ID

var job_refrence = ["Electrician","Janitor","Operator","Repairman","Cook"]

func refresh_players(players):
	for player_id in players:
		var playerName = players[player_id]["Player_name"]
		var playerJob = players[player_id]["Job"]
		item_list.set_item_text(playerJob, " "+playerName)
		item_list.set_item_disabled(playerJob, true)
	id_label.text = "Lobby ID: "+Server.lobby_id


func _on_Copy_pressed() -> void:
	OS.clipboard = Server.lobby_id
	$VBoxContainer/Copy/Label.text = "Copied!"
	$VBoxContainer/Copy.disabled = true
	yield(get_tree().create_timer(3), "timeout")
	$VBoxContainer/Copy/Label.text = "Copy Lobby ID"
	$VBoxContainer/Copy.disabled = false


func _on_ItemList_item_selected(index: int) -> void:
	if !item_list.is_item_disabled(index):
		var old_job = Server.player_data["Job"]
		Server.player_data["Job"] = index
		Server.update_job(old_job)


func update_old_job(old_job):
	item_list.set_item_text(old_job, " "+job_refrence[old_job])
	item_list.set_item_disabled(old_job, false)

