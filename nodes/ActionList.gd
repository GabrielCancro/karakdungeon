extends ColorRect

func _ready():
	visible = false
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
	if !player.action: return
	var ac_array = ActionManager.get_room_actions()
	visible = (ac_array.size()>0)
	for ac_name in ac_array:
		var ac = load("res://nodes/ActionNode.tscn").instance()
		var text = Lang.get_text("ac_"+ac_name)
		if Utils.is_mobile: text += "\n[color=#707070]("+Lang.get_text("tx_touch_again")+")[/color]"
		AdaptativeHintAuto.add_hint(ac.get_node("Button"),text)
		ac.set_action(ac_name)
		$List.add_child(ac)
	order_actions()

func order_actions():
	for ac in $List.get_children():
		var i = ac.get_index()
		ac.rect_position = Vector2(i*5,i*90)

func block():
	$block.visible = true

func unblock():
	$block.visible = false
