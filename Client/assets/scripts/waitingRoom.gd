extends TextureRect

onready var item_list = $VBoxContainer/ItemList
onready var id_label = $VBoxContainer/ID

var job_refrence = ["Electrician","Janitor","Operator","Repairman","Cook"]


func refresh_players(players):
	for player_id in players:
		var playerName = players[player_id]["Player_name"]
		var playerJob = players[player_id]["Role"]
		item_list.set_item_text(playerJob, " "+playerName)
		item_list.set_item_disabled(playerJob, true)
	id_label.text = "Lobby ID: "+Server.lobby_id


func _on_Copy_pressed() -> void:
	#copy ID
	OS.clipboard = Server.lobby_id
	
	#Disable button
	$VBoxContainer/Copy/Label.text = "Copied!"
	$VBoxContainer/Copy.disabled = true
	
	yield(get_tree().create_timer(3), "timeout")
	
	#Enable button
	$VBoxContainer/Copy/Label.text = "Copy Lobby ID"
	$VBoxContainer/Copy.disabled = false


#Change jobs
func _on_ItemList_item_selected(index: int) -> void:
	if !item_list.is_item_disabled(index):
		var old_job = Server.player_data["Role"]
		Server.player_data["Role"] = index
		Server.update_job(old_job)


#Remove old job
func update_old_job(old_job):
	item_list.set_item_text(old_job, " "+job_refrence[old_job])
	item_list.set_item_disabled(old_job, false)

