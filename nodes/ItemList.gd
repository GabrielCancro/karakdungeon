extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Img/AnimationPlayer.stop()
	$lb_level.text = Lang.get_text("tx_inventory")
	AdaptativeHintAuto.add_hint($HelpButton,Lang.get_text("hint_items"))
	yield(get_tree().create_timer(.2),"timeout")
	update_item_list()

func update_item_list():
	Utils.remove_all_childs($Items)
	var party_items = ItemManager.get_party_items()
	$Items.columns = 1+floor((party_items.keys().size()-1)/5)
	#print("@COLUMNS   ",$Items.columns)
	for it_name in party_items.keys():
		var itnode = load("res://nodes/ItemNode.tscn").instance()
		itnode.set_data(party_items[it_name])
		$Items.add_child(itnode)
	update_usables()

func update_usables():
	for it in $Items.get_children():
		it.set_can_use(true)
		it.get_node("border").modulate = Color(.5,.5,.4,1)
		if (ItemManager.has_method("condition_"+it.data.name) 
		&& !ItemManager.call("condition_"+it.data.name,it.data)): 
			it.set_can_use(false)
		if ("uses"in it.data) && (it.data["uses"]<=0): 
			it.set_can_use(false)

func play_take_item_anim(it_name):
	$Img.texture = load("res://assets/items/it_"+it_name+".png")
	$Img/AnimationPlayer.play("anim1")
	yield($Img/AnimationPlayer,"animation_finished")
	update_item_list()
