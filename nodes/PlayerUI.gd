extends ColorRect

var id = null

func _ready():
	$btn_roll.connect("button_down",self,"roll_dices")
	$btn_select.connect("button_down",self,"on_select")
	roll_dices()

func set_player(_id):
	id = _id
	$TextureRect.texture = PlayerManager.get_player_data(id).retrait

func roll_dices():
	for d in $HBoxContainer.get_children():
		d.roll()

func get_dices():
	var arr = []
	for d in $HBoxContainer.get_children(): 
		arr.append(d.value)
	return arr

func on_select():
	PlayerManager.change_player(id)

func set_selected(val):
	$ColorRect.visible = val
