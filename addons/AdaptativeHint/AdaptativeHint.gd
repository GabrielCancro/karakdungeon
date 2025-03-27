extends CanvasLayer

var offsetMouse = Vector2(35,20)

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_panel()

func _process(delta):
	$Panel.rect_global_position = get_viewport().get_mouse_position() + offsetMouse

func show_panel(text):
	$Panel/RTL.bbcode_text = "[center]"+text
	#$Panel/RTL.bbcode_text = "[center]"+Lang.get_text("ac_"+ac_name)
	#$Panel.rect_global_position.y = node.rect_global_position.y
	$Panel/RTL.rect_position = Vector2(50,50)
	$Panel.rect_size.y = 100+$Panel/RTL.get_content_height()
	visible = true
	set_process(true)

func hide_panel():
	visible = false
	$Panel/RTL.bbcode_text = ""
	set_process(false)
