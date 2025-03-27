extends CanvasLayer

var offsetMouse = Vector2(35,20)

var shortkeys = {
	"@POTION": "[img=40]res://addons/AdaptativeHint/assets/shortkey_potion.png[/img]"
}

# Called when the node enters the scene tree for the first time.
func _ready():
	hide_panel()

func _process(delta):
	$Panel.rect_global_position = get_viewport().get_mouse_position() + offsetMouse

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
