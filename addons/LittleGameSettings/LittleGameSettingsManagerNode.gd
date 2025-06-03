extends Node

func _ready():
	initialize_manager()

##FULLSCREEN
func toogle_fullscreen():
	settings_data.fullscreen = !OS.window_fullscreen
	OS.window_fullscreen = settings_data.fullscreen
	save_settings_data()

##LOCALIZATION
var localization_class = load("res://addons/LittleGameSettings/example_localizated_strings.gd")

func get_lang():
	var languajes = localization_class.languajes()
	return languajes[settings_data.lang_index]

func next_lang():
	var languajes = localization_class.languajes()
	settings_data.lang_index += 1
	if settings_data.lang_index>=languajes.size(): settings_data.lang_index = 0
	save_settings_data()
	return get_lang()

func get_localizated_string(code):
	var localizated_strings = localization_class.localizated_strings()
	var loc_in_lang = localizated_strings[get_lang()]
	if code in loc_in_lang: 
		var text = loc_in_lang[code]
		var shortkeys = localization_class.shortkeys()
		for sk in shortkeys.keys():
			text = text.replace(sk,"[font=res://addons/LittleGameSettings/assets/bbcode_icon_align.tres]"+shortkeys[sk]+"[/font]")
		return text
	else: 
		return get_lang()+":"+code

##SAVEDATA SETTINGS
var settings_data = {'version':1, 'fullscreen':true, 'lang_index':0, 'sfx_vol':100, 'music_vol':100}

func save_settings_data():
	var file = File.new()
	file.open("user://settings.res", File.WRITE)
	file.store_string(var2str(settings_data))
	file.close()

func load_settings_data():  
	var file = File.new()
	file.open("user://settings.res", File.READ)
	var loaded_data = str2var(file.get_as_text())
	file.close()
	if(loaded_data && "version" in loaded_data && loaded_data.version>=settings_data.version):
		settings_data = loaded_data

##SAVEDATA CUSTOM
func save_custom_data(_data):
	var file = File.new()
	file.open("user://savedata.res", File.WRITE)
	file.store_string(var2str(_data))
	file.close()

func load_custom_data():  
	var file = File.new()
	file.open("user://savedata.res", File.READ)
	var custom_data = str2var(file.get_as_text())
	file.close()
	return custom_data

#CLEAR ALL USER DATA
func clear_data():
	var dir = Directory.new()
	var file = File.new()
	if file.file_exists("user://settings.res"):
		dir.remove("user://settings.res")
	if file.file_exists("user://savedata.res"):
		dir.remove("user://savedata.res")
	#get_tree().quit()

#SOUNDS AND MUSIC
var preload_sounds = []
var current_music
var custom_sounds_folder = "res://assets/sounds/"

func _get_stream(code):
	var stream = null
	#LOAD DIRECTLY
	stream = _get_resource(code)
	if stream: return stream
	#LOAD FROM CUSTOM PATH
	stream = _get_resource(custom_sounds_folder+code+".ogg")
	if stream: return stream
	stream = _get_resource(custom_sounds_folder+code+".wav")
	if stream: return stream
	stream = _get_resource(custom_sounds_folder+code+".mp3")
	if stream: return stream
	#LOAD FROM DEFAULTS
	stream = _get_resource("res://addons/LittleGameSettings/assets/sounds/"+code+".ogg")
	if stream: return stream
	stream = _get_resource("res://addons/LittleGameSettings/assets/sounds/"+code+".wav")
	if stream: return stream
	stream = _get_resource("res://addons/LittleGameSettings/assets/sounds/"+code+".mp3")
	if stream: return stream
	#ERROR!
	push_error("LittleGS ERROR: dont exist sound file to - "+str(code))
	return null

func _get_resource(path):
	if ResourceLoader.exists(path): return load(path)
	else: return null

func play_sound(name,vol=100):
	var audio = AudioStreamPlayer.new()
	audio.set_bus("sfx")
	add_child(audio)
	audio.stream = _get_stream(name)
	assert(audio.stream)
	if !audio.stream: return
	audio.stream.loop = false
	audio.volume_db = (vol-100)*0.33
	audio.play()
	audio.connect("finished",audio,"queue_free")
	return audio

func stop_all_sounds():
	for a in get_children():
		if a is AudioStreamPlayer && is_instance_valid(a) && a != current_music:
			a.stop()
			a.queue_free()

func play_music(name=null,vol=100):
	if name:
		current_music.stream = _get_stream(name)
		assert(current_music.stream) #THE SOUND FILE DONT LOADED!!
		current_music.stream.loop = true
		current_music.volume_db = (vol-100)*0.33
	if current_music:
		current_music.volume_db = (vol-100)*0.33
		current_music.play()
	return current_music

func stop_music():
	if current_music:
		current_music.stop()

func set_vol(val=100,bus="Master"):
	var db = (val-100)*0.33
	var bus_index = AudioServer.get_bus_index(bus)
	AudioServer.set_bus_volume_db(bus_index, db )
	AudioServer.set_bus_mute(bus_index, (val==0) )
	settings_data[bus+"_vol"] = val
	save_settings_data()

func get_vol(bus="Master"):
	var bus_index = AudioServer.get_bus_index(bus)
	var db = AudioServer.get_bus_volume_db(bus_index)
	if AudioServer.is_bus_mute(bus_index): return 0
	else: return floor(db/0.33+100)

func initialize_manager():
	load_settings_data()
	OS.window_fullscreen = settings_data.fullscreen
	AudioServer.add_bus(1)
	AudioServer.set_bus_name(1,"sfx")
	AudioServer.add_bus(2)
	AudioServer.set_bus_name(2,"music")
	set_vol(settings_data.sfx_vol,"sfx")
	set_vol(settings_data.music_vol,"music")
	current_music = AudioStreamPlayer.new()
	current_music.set_bus("music")
	add_child(current_music)

func add_to_scene():
	get_node("/root").add_child(self)
