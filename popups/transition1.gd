extends CanvasLayer

signal on_close()

func _ready():
	Effector.appear($TextureRect)
	yield(get_tree().create_timer(1),"timeout")
	Effector.disappear($TextureRect)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("on_close")
	queue_free()

func set_page(page=null): pass
