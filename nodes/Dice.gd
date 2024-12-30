extends ColorRect

var faces = ["BT","HN","SW","EY"]
var value = null

signal end_roll()

func _ready():
	hover_dice(false)
	$Button.connect("mouse_entered",self,"hover_dice",[true])
	$Button.connect("mouse_exited",self,"hover_dice",[false])

func set_faces(arr):
	faces = arr
	for i in faces.size(): get_node("Faces/Grid/f"+str(i+1)).texture = load("res://assets/dices/"+faces[i]+".png")
	color = PlayerManager.get_dice_color(faces)
	$Faces.color = color
	$Faces/ColorRect.color = color

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

func hover_dice(val):
	$Faces.visible = val
