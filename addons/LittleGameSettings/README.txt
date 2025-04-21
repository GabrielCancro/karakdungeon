Little Game Settings

This plugin contain a serie of tools to work in fastly prototypes or short games. 
This have simples globals functions to manage all features in LittleGameSettingsAuto autoload script.

It will have:

OPTIONS PANEL
-Option Panel: a simple panel to change settings of game 
(language, fullscreen, clear data, credits, volummens)

you only need call "add_options_panel_to_scene(scene)"


-Fullscreen Manager

-Save Game Data and Settings Data

-Localization to some languajes
signal lenguaje_change is wanted when you need relocalizate strings in the current scene

SOUND MODULE
-Basic Sound and music manager with a little reusable sfx collection files in .ogg .wav or .mp3
-The default folder to assets is "res://assets/sounds/", but you can change calling "set_custom_sounds_folder(path)"

functions:
	set_custom_sounds_folder(path)
	play_sound(name,vol=100) (play in sfx bus without loops)
	stop_all_sounds()
	play_music(name=null,vol=100) (play only one currency in loop in "music" bus)
	stop_music()
	