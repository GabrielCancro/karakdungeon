extends CanvasLayer

signal on_close()


# Called when the node enters the scene tree for the first time.
func _ready():
	$Panel/Button.connect("button_down",self,"on_click_close")
	$Arrow1.rect_global_position =  Vector2(15,-20)+PlayerManager.get_player_data(1).ui.rect_global_position
	$Arrow2.rect_global_position =  Vector2(15,-20)+PlayerManager.get_player_data(2).ui.rect_global_position
	$Arrow3.rect_global_position =  Vector2(15,-20)+PlayerManager.get_player_data(3).ui.rect_global_position

func on_click_close():
	emit_signal("on_close")
	queue_free()
