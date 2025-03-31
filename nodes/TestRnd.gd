extends Control

var fail = 3
var success = 7
var result

var DIF_TABLE = [
	[0,3],[1,4],[2,5],[3,5],[4,6],[5,7],[6,8],[7,8]
]

signal end_roll(result)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"roll")
	set_dif(5)

func set_dif(dif):
	fail = DIF_TABLE[dif][0]
	success = DIF_TABLE[dif][1]
	$lb_num.text = str(dif)
	$Selector.visible = false
	for c in $Grid.get_children():
		var i = c.get_index()+1
		if i<=fail: c.modulate = Color(1,.5,.5)
		elif i<success: c.modulate = Color(.8,.8,.8)
		else: c.modulate = Color(1,1,.5)

func roll():
	randomize()
	$Selector.modulate.a = .7
	$Selector.visible = true
	$Timer.start()
	var index = -1
	for i in range(15):
		var rn = randi()%10
		var c = $Grid.get_child(rn)
		index = c.get_index()+1
		$Selector.rect_global_position = c.rect_global_position - Vector2(4,4)
		yield($Timer,"timeout")
	$Timer.stop()
	$Selector.modulate.a = 1
	var result = "NONE"
	if index<=fail: result = "FAIL"
	if index>=success: result = "SUCCESS"
	emit_signal("end_roll",result)
