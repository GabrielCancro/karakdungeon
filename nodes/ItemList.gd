extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.2),"timeout")
	update_item_list()

func update_item_list():
	on_hover_item("",false)
	Utils.remove_all_childs($Items)
	var party_items = ItemManager.get_party_items()
	for it_name in party_items.keys():
		var itnode = preload("res://nodes/ItemNode.tscn").instance()
		itnode.set_data(party_items[it_name])
		itnode.connect("on_hover",self,"on_hover_item")
		$Items.add_child(itnode)
	update_usables()

func update_usables():
	for it in $Items.get_children():
		it.modulate = Color(1,1,1,1)
		if (ItemManager.has_method("condition_"+it.data.name) 
		&& !ItemManager.call("condition_"+it.data.name,it.data)): 
			it.modulate = Color(.3,.3,.3,1)
		if ("uses"in it.data) && (it.data["uses"]<=0): 
			it.modulate = Color(.3,.3,.3,1)

func on_hover_item(it_name,val,node=null):
	if !node:return
	$desc/RTL.bbcode_text = "[color=#FF9999][u]"+Lang.get_text("it_"+it_name+"_name")+":[/u][/color] "
	$desc/RTL.bbcode_text += Lang.get_text("it_"+it_name+"_desc")
	$desc.rect_global_position.y = node.rect_global_position.y
	$desc/RTL.rect_position.y = 15
	$desc.rect_size.y = 30+$desc/RTL.get_content_height()
	$desc.visible = val
