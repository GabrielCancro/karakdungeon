extends Node2D

var data
var defiance = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_data(room_data):
	data = room_data
	if "defiance" in data: data["defiance"] = DefianceManager.get_defiance_data(data["defiance"])
	$Sprite.visible = ("defiance" in data)
