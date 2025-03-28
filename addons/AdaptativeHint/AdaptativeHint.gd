extends CanvasLayer

var offsetMouse = Vector2(10,10)
onready var screenSize = get_viewport().get_visible_rect().size
onready var shortkeys = load("res://addons/AdaptativeHint/assets/shortkeys.gd").shortkeys()

func _ready():
	hide_panel()

func _process(delta):
	$Panel.rect_global_position = get_viewport().get_mouse_position() + offsetMouse
	if $Panel.rect_global_position.x>screenSize.x*0.7: 
		$Panel.rect_global_position.x -= $Panel.rect_size.x + offsetMouse.x*2
	if $Panel.rect_global_position.y>screenSize.y*0.7: 
		$Panel.rect_global_position.y -= $Panel.rect_size.y + offsetMouse.y*2

func show_panel(text):
	$Panel/RTL.bbcode_text = "[center]"
	$Panel/RTL.bbcode_text += replace_shortkeys(text)
	$Panel/RTL.bbcode_text += "[/center]"
	$Panel/RTL.rect_position = Vector2(50,50)
	$Panel.rect_size.y = 100+$Panel/RTL.get_content_height()
	visible = true
	set_process(true)

func replace_shortkeys(text):
	for sk in shortkeys.keys():
		text = text.replace(sk,"[font=res://addons/AdaptativeHint/assets/bbcode_icon_align.tres]"+shortkeys[sk]+"[/font]")
	return text

func hide_panel():
	visible = false
	$Panel/RTL.bbcode_text = ""
	set_process(false)
