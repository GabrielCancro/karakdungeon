extends ColorRect

func _ready():
	$Button.connect("button_down",self,"roll_dices")
	roll_dices()

func roll_dices():
	for d in $HBoxContainer.get_children():
		d.roll()

func get_dices():
	var arr = []
	for d in $HBoxContainer.get_children(): 
		arr.append(d.value)
	return arr
