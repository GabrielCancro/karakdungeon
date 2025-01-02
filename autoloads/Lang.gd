extends Node

var lang = "es"

var texts = {
	"df_enemy_es":"Te atacará si te mueves o realizas una acción.",
	"df_trap_es":"Se activa si atraviesas la habitación.",
	"df_block_es":"No puedes pasar por aquí hasta que destruyas este obstáculo.",
	"df_door_es":"No puedes pasar por aquí hasta que abras el cerrojo.",
	"df_stairs_es":"Obtén la llave de este piso y reúne a tus personajes aquí para descender al siguiente nivel.",
	"df_fountain_es":"Esta fuente sanará hasta 2HP a quien beba de ella.",
	
	"ac_attack_es":"Causa entre 0 y 2 de daño, cada @SW añade un golpe extra.",
	"ac_dissarm_es":"Cada @HN y cada @EY mejora la posibilidad de éxito.",
	"ac_unlock_es":"Completa los requisitos según los atributos actuales del personaje.",
	"ac_force_es":"20% de destruir el primer requisito, esté o no resuelto.",
	"ac_recover_es":"Curas tus puntos de vida (HP). Puede agotarse.",
}

var images = {
	"@SW":"[font=res://assets/font/bbcode_font.tres][img=40]res://assets/dices/SW.png[/img][/font]",
	"@HP":"[font=res://assets/font/bbcode_font.tres][img=40]res://assets/bbimg/bb_hp.png[/img][/font]",
	"@HN":"[font=res://assets/font/bbcode_font.tres][img=40]res://assets/dices/HN.png[/img][/font]",
	"@EY":"[font=res://assets/font/bbcode_font.tres][img=40]res://assets/dices/EY.png[/img][/font]"
}

func get_text(code,vals = []):
	var lang_code = code+"_"+lang
	if !lang_code in texts: return "<"+lang_code+">"
	else: 
		var tx = texts[lang_code]
		for i in range(vals.size()): tx = tx.replace("#"+str(i+1),str(vals[i]))
		for k in images.keys(): 
			#var am = PlayerManager.get_dice_amount(k.substr(1))
			tx = tx.replace(k,images[k]) #+"("+str(am)+")")
		return tx

func get_img(code):
	return images[code]
