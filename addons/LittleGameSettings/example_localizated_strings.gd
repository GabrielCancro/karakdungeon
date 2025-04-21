extends Node

static func languajes():
	return ["es","en"]

static func localizated_strings():
	return {
		"es":{
			"example":"Bienvenido al localizador express! @LGS",
		},
		"en":{
			"example":"Welcom to express localizator! @LGS",
		}
	}

static func shortkeys():
	#specially util to bb_code, replace images or anythings
	return {
		"@LGS":"[img=45]res://addons/LittleGameSettings/icon.png[/img]"
	}
