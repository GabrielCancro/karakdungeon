extends Control

var data


# Called when the node enters the scene tree for the first time.
func set_data(_data):
	data = _data
	$TextureProgress.texture_under = data.retrait
	$TextureProgress.texture_progress = data.retrait
	$lb_name.text = data.name
	set_dices()
	set_items()
	
func set_dices():
	Utils.remove_all_childs($DiceBox)
	for dice_faces in data.dices:
		var node = preload("res://nodes/Dice.tscn").instance()
		$DiceBox.add_child(node)
		node.set_faces(dice_faces)
	for d in $DiceBox.get_children():
		d.show_all_faces_loop()

func set_items():
	Utils.remove_all_childs($ItemBox)
	for item_name in data.items:
		var node = preload("res://nodes/ItemNode.tscn").instance()
		$ItemBox.add_child(node)
		node.set_data(ItemManager.get_item_data(item_name))
