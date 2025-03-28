extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	yield(get_tree().create_timer(.2),"timeout")
	update_item_list()

func update_item_list():
	Utils.remove_all_childs($Items)
	var party_items = ItemManager.get_party_items()
	for it_name in party_items.keys():
		var itnode = preload("res://nodes/ItemNode.tscn").instance()
		itnode.set_data(party_items[it_name])
		var text = "[u][color=#90F090]"+Lang.get_text("it_"+it_name+"_name")+"[/color][/u]\n"+Lang.get_text("it_"+it_name+"_desc")
		AdaptativeHintAuto.add_hint(itnode.get_node("Button"),text)
		$Items.add_child(itnode)
	update_usables()

func update_usables():
	for it in $Items.get_children():
		it.color = Color(0,.2,.35,1)
		if (ItemManager.has_method("condition_"+it.data.name) 
		&& !ItemManager.call("condition_"+it.data.name,it.data)): 
			it.color = Color(.15,.15,.15,1)
		if ("uses"in it.data) && (it.data["uses"]<=0): 
			it.color = Color(.15,.15,.15,1)

