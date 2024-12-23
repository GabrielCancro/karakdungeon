tool
extends RichTextEffect
class_name RichTextHover

var bbcode := "imgfx"

func _process_custom_fx(char_fx):
	
	var speed = char_fx.env.get("speed", 15.0)

	var offset := Vector2(0, sin(char_fx.elapsed_time * speed))
	char_fx.offset = offset
	return true
