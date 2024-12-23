extends ColorRect

func _ready():
	ActionManager.ACTION_LIST_NODE = self
	DungeonManager.connect("change_room",self,"show_current_actions")

func show_current_actions():
	var room = DungeonManager.current_room
	var player = DungeonManager.current_player
	var defiance = null
	if room && "defiance" in room.data: defiance = room.data.defiance
	Utils.remove_all_childs($List)
	visible = (defiance!=null)
	if !defiance: return
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

func block():
	$block.visible = true

func unblock():
	$block.visible = false
