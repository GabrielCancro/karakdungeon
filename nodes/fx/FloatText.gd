extends Node2D

func _ready():
	z_index = 999
	$Tween.interpolate_property(self,"position",position,position+Vector2(0,-50),1.5,Tween.TRANS_QUAD,Tween.EASE_IN)
	$Tween.interpolate_property(self,"modulate",Color(1,1,1,1),Color(1,1,1,0),.5,Tween.TRANS_QUAD,Tween.EASE_IN,1.0)
	$Tween.start()
	yield($Tween,"tween_all_completed")
	queue_free()

func set_float(text,pos,style="normal"):
	position = pos
	$Label.text = text
	if style=="normal": $Label.add_color_override("font_color",Color(.9,.9,.4,1))
	elif style=="damage": $Label.add_color_override("font_color",Color(1,.5,.5,1))
	elif style=="white": $Label.add_color_override("font_color",Color(.8,.8,.8,1))

