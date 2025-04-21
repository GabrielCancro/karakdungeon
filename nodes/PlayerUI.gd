extends ColorRect

var data

func _ready():
	$btn_roll.connect("button_down",self,"roll_dices")
	$btn_select.connect("button_down",self,"on_select")
	set_selected(false)
	roll_dices()

func set_player(id):
	data = PlayerManager.get_player_data(id)
	$TextureProgress.texture_under = data.retrait
	$TextureProgress.texture_progress = data.retrait
	$lb_name.text = data.name
	restore_original_dices()
	updateUI()

func restore_original_dices():
	Utils.remove_all_childs($HBox)
	for dice_faces in data.dices:
		var node = preload("res://nodes/Dice.tscn").instance()
		node.set_faces(dice_faces)
		$HBox.add_child(node)

func updateUI():
	$lb_hp.text = str(data.hp)+"/"+str(data.hpm)
	$TextureProgress.max_value = data.hpm
	$TextureProgress.value = data.hpm - data.hp
	#$lb_mov.text = "MOV: "+str(data.mov)+"/"+str(data.movm)
	update_mov_ui()
	data.node.update_hp()
	set_selected()

func update_mov_ui():
	var radius = 50
	var step = 0.30
	var offset = 2.70
	
	for m in $mov.get_children():
		var i = m.get_index()
		var ri = step*i+offset
		if i >= data.movm: 
			ri += step/2
			m.modulate = Color(.1,.8,.1,1)
		else:
			if i < data.mov: m.modulate = Color(1,1,1,1)
			else: m.modulate = Color(.3,.3,.3,1)
		m.visible = (i<data.mov or i<data.movm)
		m.rect_position = Vector2(cos(ri),sin(ri))*radius - m.rect_size/2

func roll_dices():
	for d in $HBox.get_children():
		d.roll()

func add_dice_face(face):
	#print("add_dice_face ",face)
	var node = preload("res://nodes/Dice.tscn").instance()
	node.set_one_face(face)
	$HBox.add_child(node)
	updateUI()
	DungeonManager.reset_current_room()

func get_dices():
	var arr = []
	for d in $HBox.get_children(): 
		arr.append(d.value)
	return arr

func quit_dice(face):
	for d in $HBox.get_children(): 
		if d.value==face: 
			$HBox.remove_child(d)
			d.queue_free()
			return true

func on_select():
	PlayerManager.change_player(data.id)

func set_selected(val=$Selector.visible):
	$Selector.visible = val
	if val: modulate = Color(1,1,1,1)
	else: modulate = Color(.7,.7,.7,1)
	#print("data.action ",data.action)
	if data.action: $HBox.modulate = Color(1,1,1,1)
	else: $HBox.modulate = Color(.5,.5,.5,.5)
	
