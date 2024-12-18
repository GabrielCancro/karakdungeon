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
	Utils.remove_all_childs($List)
	if defiance: 
		$Label.text += defiance.name
		$Label.text += "\n*****************"
		var ac_array = ActionManager.get_room_actions()
		for ac_name in ac_array:
			var ac = preload("res://nodes/ActionNode.tscn").instance()
			ac.set_action(ac_name)
			$List.add_child(ac)
		order_actions()

func order_actions():
	for ac in $List.get_children():
		var i = ac.get_index()
		ac.rect_position = Vector2(0,i*120)
#		$Tween.interpolate_property(ac,"rect_position",null,Vector2(0,i*120),.2,Tween.TRANS_QUAD,Tween.EASE_OUT,i*.1)
#	$Tween.start()
