extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if !Utils.is_mobile: 
		queue_free()
		return
	LittleGS.add_button_behavior($up)
	LittleGS.add_button_behavior($down)
	LittleGS.add_button_behavior($left)
	LittleGS.add_button_behavior($right)
	$up.connect("button_down",self,"on_up")
	$down.connect("button_down",self,"on_down")
	$left.connect("button_down",self,"on_left")
	$right.connect("button_down",self,"on_right")

func on_up(): move(0,-1)
func on_down(): move(0,+1)
func on_left(): move(-1,0)
func on_right(): move(+1,0)

func move(x,y):
	print("MOVE ",x,"_",y)
	if Utils.is_input_disabled(): return
	if !DungeonManager.current_player: return
	if Utils.current_popup: return
	if !DungeonManager.current_player.action: return
	DungeonManager.current_player.node.move_to(x,y)
