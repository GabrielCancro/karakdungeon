extends Node

var lang = "es"

var texts = {
	"ab_desc_direct_attack_es": "Ataque Directo: Consume 2x@SW para dañar 1xVIDA a un enemigo. #1",
	"df_enemy_es":"Te atacará si te mueves o realizas una acción. Además ataca a un personaje aleatorio al finalizar el turno.",
	"ac_attack_es":"Causa (0-2) de daño, además cada @SW añade (0-2) de daño extra.",
	"ac_dissarm_es":"Cada @HN y cada @EY mejora la posibilidad de éxito.",
	"ac_unlock_es":"Completa los requisitos según los atributos actuales del personaje.",
	"ac_force_es":"50% de destruir el primer requisito, esté o no resuelto.",
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
		if "@" in tx: 
			for k in images.keys(): tx = tx.replace(k,images[k])
			return tx
		else: return tx
		
