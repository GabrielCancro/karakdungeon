extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func show_current_actions(room,player):
	var defiance = null
	if room && "defiance" in room.data: defiance = room.data.defiance
	$Label.text = ""
	if defiance: 
		$Label.text += defiance.name
		$Label.text += "\n*****************"
		for action in DefianceManager.get_actions(defiance.type):
			$Label.text += "\n"+str(action)
