extends Node

var disabled_input_timer = 0
var DISABLED_ACTIONS = false
var current_popup = null
var is_mobile = true

func _ready():
	#is_mobile = OS.has_feature("mobile") || OS.has_feature("web_android") || OS.has_feature("web_ios")|| OS.has_feature("android") || OS.has_feature("ios")
	is_mobile = true#JavaScript.eval("/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)", true)

func set_zindex(node, delay=0,offsetY=0):
	if delay>0: yield(get_tree().create_timer(delay),"timeout")
	node.z_index = 500+(node.global_position.y+offsetY)/20
	if DungeonManager.current_player && node==DungeonManager.current_player.node: node.z_index += 2
	#print(node.name,"  zindex ",node.z_index)

func remove_all_childs(node):
	for n in node.get_children():
		node.remove_child(n)
		n.queue_free()

func _process(delta):
	if disabled_input_timer>0: 
		disabled_input_timer -= delta
		get_node_or_null("/root/Game/CLUI/InputBlocker").modulate.a = min(1,disabled_input_timer*2)
	else: enable_input()

func disable_input(t):
	if disabled_input_timer<t:
		set_process(true)
		disabled_input_timer = t
		var bn = get_node_or_null("/root/Game/CLUI/InputBlocker")
		if bn: bn.visible = true

func enable_input():
	set_process(false)
	disabled_input_timer = 0
	var bn = get_node_or_null("/root/Game/CLUI/InputBlocker")
	if bn: bn.visible = false

func is_input_disabled():
	return (disabled_input_timer>0 || DISABLED_ACTIONS)

func show_popup(name,page=null):
	var node = load("res://popups/"+name+".tscn").instance()
	current_popup = node
	node.set_page(page)
	get_node("/root").add_child(node)
	node.connect("on_close",self,"_on_close_popup")
	return node

func _on_close_popup():
	current_popup = null
