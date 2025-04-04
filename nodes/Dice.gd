extends ColorRect

var faces = ["BT","HN","SW","EY"]
var value = null

signal end_roll()

func _ready():
	pass

func set_faces(arr):
	faces = arr
	var text = "[color=#"+PlayerManager.get_dice_color(faces).to_html()+"]"+Lang.get_text("dice_"+PlayerManager.get_dice_type(faces))+"[/color]\n"
	for i in faces.size(): text+=" @"+faces[i]+" "
	AdaptativeHintAuto.add_hint($Button,text)
	color = PlayerManager.get_dice_color(faces)

func roll():
	randomize()
	for i in range(10):
		var index = randi()%faces.size()
		value = faces[index]
		$img.rect_rotation = rand_range(-50,50)
		$img.texture = load("res://assets/dices/"+value+".png")
		yield(get_tree().create_timer(.1),"timeout")
	$img.rect_rotation = 0
	emit_signal("end_roll")

func set_one_face(face):
	set_faces([face,face,face,face,face,face])
	value = face
	$img.texture = load("res://assets/dices/"+value+".png")

func show_all_faces_loop():
	for f in faces:
		$img.texture = load("res://assets/dices/"+f+".png")
		$img.rect_rotation = rand_range(-50,50)
		yield(get_tree().create_timer(rand_range(.4,.7)), "timeout")
	show_all_faces_loop()
