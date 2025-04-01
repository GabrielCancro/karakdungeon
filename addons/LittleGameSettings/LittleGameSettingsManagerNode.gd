extends Node

##FULLSCREEN
func toogle_fullscreen():
	settings_data.fullscreen = !OS.window_fullscreen
	OS.window_fullscreen = settings_data.fullscreen
	save_settings_data()

##LOCALIZATION
onready var Languajes = load("res://addons/LittleGameSettings/assets/localizated_strings.gd").languajes()
onready var localizated_strings = load("res://addons/LittleGameSettings/assets/localizated_strings.gd").localizated_strings()

func get_lang():
	return Languajes[settings_data.lang_index]

func next_lang():
	settings_data.lang_index += 1
	if settings_data.lang_index>=Languajes.size(): settings_data.lang_index = 0
	save_settings_data()
	return get_lang()

func get_localizated_string(code):
	var key = code+"_"+get_lang()
	if key in localizated_strings: return localizated_strings[key]
	else: return key

##SAVEDATA SETTINGS
var settings_data = {'fullscreen':true, 'lang_index':0}

func _ready():
	load_settings_data()

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
	if(loaded_data): settings_data = loaded_data
	OS.window_fullscreen = settings_data.fullscreen

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
	get_tree().quit()
