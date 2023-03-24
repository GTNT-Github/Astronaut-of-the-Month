extends Jobs

var waypoints = []
var completed_waypoints = 0
var index = 0


#Setup
func _ready() -> void:
	generate_waypoints()
	open_task()


func generate_waypoints():
	for i in 5:
		var waypoint = generate_id(5)
		waypoints.insert(i,waypoint)
		get_node("Waypoints/Waypoint"+str(i)).text = waypoint


func _waypoint_entered(new_text: String, input_num:int) -> void:
	
	#Get node & uppercase text
	var input_node = get_node("Waypoints/Input"+str(input_num)+"/Input")
	new_text = new_text.to_upper()
	print(input_node,input_num)
	uppercase_text(input_node,new_text)
	
	#Check input to actual waypoint
	print(new_text,waypoints[input_num])
	if new_text == waypoints[input_num]:
		get_node("Waypoints/Input"+str(input_num)).self_modulate = Color(1,1,1,0)
		completed_waypoints += 1
		
		#Select next textbox
		if input_num != 4:
			get_node("Waypoints/Input"+str(input_num+1)+"/Input").grab_focus()
		
		yield(play_sound("input_waypoint"),"completed")
		
		#Finish
		if completed_waypoints == 5:
			close_task()


func uppercase_text(node,text):
	var caret_pos = node.caret_position
	node.text = text
	node.caret_position = caret_pos


func generate_id(length):
	var chars = 'ABCDEFGHIJKLMNPQRSTUVWXYZ123456789'
	var word: String = ""
	var n_char = len(chars)
	for _i in range(length):
		randomize()
		word += chars[randi()%n_char]
	return word
