extends Control

var preloads = [
	load("res://assets/sounds/ambientcave.ogg"),
	load("res://assets/sounds/dungeon_steps.ogg"),
	load("res://addons/LittleGameSettings/assets/sounds/button.ogg"),
	load("res://addons/LittleGameSettings/assets/sounds/intro_splash.ogg"),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	set_autoloads()
	$Button.connect("button_down",self,"next_scene")
	var cpos = get_viewport_rect().size/2
	$Pump.position = cpos
	$Pump.position.y -= 40
	$Logo.rect_position.y -= 40
	$Pump.modulate.a = 0
	$Logo.modulate.a = 0
	$Pump.play("idle")
	MyGlobal.printer()
	
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

func set_autoloads():
	var autoloads = [
		"ActionManager",
		"DefianceManager",
		"DungeonManager",
		"Effector",
		"ItemManager",
		"Lang",
		"MapGenerator",
		"MyGlobal",
		"PlayerManager",
		"TurnManager",
		"Utils",
	]
	for au in autoloads:
		print("/root/"+au+"  ->  "+"res://autoloads/"+au+".gd")
		get_tree().root.get_node("/root/"+au).set_script(load("res://autoloads/"+au+".gd"))
