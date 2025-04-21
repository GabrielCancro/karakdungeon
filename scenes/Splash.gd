extends Control

const preloads = [
	preload("res://assets/sounds/ambientcave.ogg"),
	preload("res://assets/sounds/dungeon_steps.ogg"),
	preload("res://addons/LittleGameSettings/assets/sounds/button.ogg"),
	preload("res://addons/LittleGameSettings/assets/sounds/intro_splash.ogg"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"next_scene")
	var cpos = get_viewport_rect().size/2
	$Pump.position = cpos
	$Pump.position.y -= 40
	$Logo.rect_position.y -= 40
	$Pump.modulate.a = 0
	$Logo.modulate.a = 0
	$Pump.play("idle")
	
	$Tween.interpolate_property($Pump,"modulate:a",0,1,0.2,Tween.TRANS_QUAD,Tween.EASE_IN,1)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	LittleGS.play_sound("intro_splash")
	yield(get_tree().create_timer(1),"timeout")
	
	$Pump.play("eye")
	$Tween.interpolate_property($Logo,"modulate:a",0,1,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	$Tween.interpolate_property($Pump,"position:x",null,cpos.x-280,0.2,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	$Tween.interpolate_property($Logo,"rect_position:x",null,cpos.x-130,0.2,Tween.TRANS_LINEAR,Tween.EASE_IN,.2)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	$Pump.play("idle")
	yield(get_tree().create_timer(1),"timeout")
	$Tween.interpolate_property($Pump,"modulate:a",1,0,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property($Logo,"modulate:a",1,0,0.5,Tween.TRANS_QUAD,Tween.EASE_OUT)
	$Tween.interpolate_property($TextureRect,"modulate:a",1,0,0.3,Tween.TRANS_QUAD,Tween.EASE_OUT,.2)
	$Tween.start()
	yield(get_tree().create_timer(1),"timeout")
	next_scene()

func next_scene():
	LittleGS.stop_all_sounds()
	get_tree().change_scene("res://scenes/Menu.tscn")
