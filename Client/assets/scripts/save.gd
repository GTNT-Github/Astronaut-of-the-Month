extends Node

const SAVEGAME = "user://Savegame.json"

var save_data = {}


func _ready():
	save_data = get_data()


func get_data():
	
	#Create file
	var file = File.new()
	
	#Save file doesn't exist - create data
	if not file.file_exists(SAVEGAME):
		save_data = {"Player_name": "Unnamed","Job":0}
		save_game()
		
	#Get save data
	file.open(SAVEGAME, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	save_data = data
	file.close()
	return(data)


func save_game():
	
	#Save data
	var save_game = File.new()
	save_game.open(SAVEGAME, File.WRITE)
	save_game.store_line(to_json(save_data))
