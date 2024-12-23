extends ColorRect

var faces = ["AX","BT","HN","KY","PT","SC"]
var value = null

signal end_roll()

func _ready():
	pass

func roll():
	randomize()
	for i in range(15):
		var index = randi()%faces.size()
		value = faces[index]
		$img.rect_rotation = rand_range(-50,50)
		$img.texture = load("res://assets/dices/"+value+".png")
		yield(get_tree().create_timer(.1),"timeout")
	$img.rect_rotation = 0
	emit_signal("end_roll")
