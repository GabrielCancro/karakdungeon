extends Control

var data
var selected = false

# Called when the node enters the scene tree for the first time.
func set_data(_data):
	data = _data
	$Outline/Retrait.texture = data.retrait
	$lb_name.text = data.name
	$Outline/hp/lb_hp.text = str(data.hpm)
	$Outline/mv/lb_mv.text = str(data.movm)
	AdaptativeHintAuto.add_hint($Outline/hp,Lang.get_text("tx_hp"))
	AdaptativeHintAuto.add_hint($Outline/mv,Lang.get_text("tx_mv"))
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
		$Outline.rect_position.x -= 43

func select(val):
	selected = val
	if selected: $NinePatchRect.modulate = Color(1,.8,0,1)
	else: $NinePatchRect.modulate = Color(.7,.7,.6,1)
