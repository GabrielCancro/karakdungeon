extends Control

var data


# Called when the node enters the scene tree for the first time.
func set_data(_data):
	data = _data
	$Outline/Retrait.texture = data.retrait
	$lb_name.text = data.name
	$lb_hp.text = "HP:"+str(data.hpm)
	$lb_mv.text = "MV:"+str(data.movm)
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
	if data.dices.size()>3: $DiceBox.add_constant_override("separation", 0)

func set_items():
	$Item.visible = false
	if data.item:
		$Item.set_data(ItemManager.get_item_data(data.item))
		$Item.visible = true
		$Outline.rect_position.x -= 50
