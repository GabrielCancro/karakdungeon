extends Node

var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(tween)

func appear(node):
	tween.interpolate_property(node,"modulate:a",0,1,.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func disappear(node,hide_end=false):
	tween.interpolate_property(node,"modulate:a",null,0,.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
	if hide_end:
		yield(get_tree().create_timer(.5),"timeout")
		node.visible = false

func disappear_fast(node,hide_end=false):
	tween.interpolate_property(node,"modulate:a",null,0,.2,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.start()
	if hide_end:
		yield(get_tree().create_timer(.2),"timeout")
		node.visible = false

func move_to(node,pos):
	if ("rect_position" in node):
		tween.interpolate_property(node,"rect_global_position",null,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	else:
		tween.interpolate_property(node,"global_position",null,pos,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func move_to_yoyo(node,to_pos):
	var prop = "position" if ("position" in node) else "rect_position"
	var pos_ini = node.get(prop)
	tween.interpolate_property(node,prop,pos_ini,pos_ini+to_pos,.15,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.interpolate_property(node,prop,pos_ini+to_pos,pos_ini,.2,Tween.TRANS_QUAD,Tween.EASE_OUT,.15)
	tween.start()

func shake(node,power=6,time=.5):
	var isControl = ("rect_position" in node)
	var ini_pos
	if isControl: ini_pos = node.rect_position
	else: ini_pos = node.position
	randomize()
	while time>0:
		if !is_instance_valid(node): return
		if isControl: node.rect_position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		else: node.position = ini_pos + Vector2(rand_range(-power,power),rand_range(-power/2,power/2))
		time -= .025
		yield(get_tree().create_timer(.025),"timeout")
	if isControl: node.rect_position = ini_pos
	else: node.position = ini_pos

func scale_boom(node):
	var prop = "scale" if ("scale" in node) else "rect_scale"
	var origin = node.get(prop)
	tween.interpolate_property(node,prop,origin*1.3,origin,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

func resalte(node):
	var _a = node.modulate.a
	tween.interpolate_property(node,"modulate:a",1.5,_a,.3,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

#func damage_fx(node,dam):
#	show_damage_text(dam,node.position+Vector2(0,-150))
#	var spr = get_node_or_null("Sprite")
#	if spr: shake(spr)
#	tween.interpolate_property(node,"modulate",Color(1,0,0,1),Color(1,1,1,1),.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
#	tween.interpolate_property(node,"scale",Vector2(1.3,1.3),Vector2(1,1),.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
#	tween.start()

func blood_bg():
	var blood = get_node("/root/Game/CLBG/blood")
	blood.visible = true
	tween.interpolate_property(blood,"modulate:a",.5,0,.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	tween.start()

#func show_float_text(code):
#	var node = preload("res://nodes/fx/FloatText.tscn").instance()
#	node.set_float(code)
#	get_node("/root").add_child(node)

#func show_damage_text(val,pos):
#	var node = preload("res://nodes/fx/FloatText.tscn").instance()
#	node.set_damage(val,pos)
#	get_node("/root/Game/CLUI").add_child(node)

func add_hint(hint_data):
	#(hint_data.owner.name)
	#hint_data={"owner":self,"panel":null,"code":"tx_code","over_node":null,"callback":null}
	var over_area = hint_data["owner"]
	if "over_area" in hint_data: over_area = hint_data["owner"].get_node(hint_data["over_area"])
	over_area.connect("mouse_entered",self,"_on_hint_enter_area",[hint_data,true])
	over_area.connect("mouse_exited",self,"_on_hint_enter_area",[hint_data,false])
	if hint_data["over_node"]: hint_data["owner"].get_node(hint_data["over_node"]).visible = false
	#node.connect("tree_exited",self,"_on_hint_enter_area",[node,tx_code,false])

func _on_hint_enter_area(hint_data,val):
	#print(hint_data)
	if hint_data.panel:
		var HintPanel
		if hint_data.panel=="default": HintPanel = get_node("/root/Game/CLUI/HintPanel")
		if hint_data.panel=="enemy": HintPanel = get_node("/root/Game/CLUI/HintPanelEnemy")
		if hint_data.panel=="army": HintPanel = get_node("/root/Game/CLUI/HintPanelArmy")
		if hint_data.panel=="item": HintPanel = get_node("/root/Game/CLUI/HintPanelItem")
		if val: HintPanel.show_hint(hint_data)
		else: HintPanel.hide_hint()
	hint_data["is_visible"] = val
	if hint_data["over_node"]: hint_data["owner"].get_node(hint_data["over_node"]).visible = val
	if hint_data["callback"]: hint_data["owner"].call(hint_data["callback"]) 

func add_over(node):
	node.connect("mouse_entered",self,"_on_over_enter_area",[node,true])
	node.connect("mouse_exited",self,"_on_over_enter_area",[node,false])
	_on_over_enter_area(node,false)

func _on_over_enter_area(node,val):
	node.get_node_or_null("HintNode").visible = val

func remove_all_children(node):
	for sl in node.get_children(): 
		node.remove_child(sl)
		sl.queue_free()

#func change_scene_transition(scene_name):
#	var trnode = preload("res://nodes/fx/TransitionNode.tscn").instance()
#	get_node("/root").add_child(trnode)
#	trnode.show_transition()
#	yield(trnode,"end_transition")
#	get_tree().change_scene("res://scenes/"+scene_name+".tscn")
#	trnode.hide_transition(true)
#	yield(get_tree().create_timer(.2),"timeout")
#	SizerManager.rescale_ui()

func fade_yoyo(node):
	tween.interpolate_property(node,"modulate",Color(1,1,1,1),Color(0,0,0,1),.25,Tween.TRANS_QUAD,Tween.EASE_IN)
	tween.interpolate_property(node,"modulate",Color(0,0,0,1),Color(1,1,1,1),.25,Tween.TRANS_QUAD,Tween.EASE_OUT,0.26)
	tween.start()

func show_float_text(text,pos,style="normal"):
	var node = preload("res://nodes/fx/FloatText.tscn").instance()
	node.set_float(text,pos,style)
	get_node("/root").add_child(node)
