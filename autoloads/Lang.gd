extends Node

var lang = "es"

var texts = {
	"ab_desc_direct_attack_es": "Ataque Directo: Consume 2x@SW para dañar 1xVIDA a un enemigo. #1",
	"ab_desc_power_attack_es": "Ataque Poderoso: Consume 3xESPADA para dañar 2xVIDA a un enemigo.",
	"ab_desc_unlock_es": "Destrabar Mecanismo: Consume 2xMANO para resolver 1xENGRANAJE de un mecanismo.",
	"ab_desc_berserk_es": "Berserker: Consume 1xVIDA para relanzar las ESPADAS INACTIVAS que tengas.",
	
	"it_desc_small_sword_es":"Espada Corta: Restaura 1xESPADA que este agotada.",
	"it_desc_large_sword_es":"Espada Larga: Restaura 2xESPADA que este agotada.",
	"small_hp_potion_es":"Pocion De Salud Menor: Restaura 2 puntos de golpe.",
	
	"slat_SW_es": "ESPADA: Estos slats te permitirán superar desafios de combate y fuerza bruta.",
	"slat_GR_es": "MECANISMO: Estos slats te permitirán superar desafios mecanicos como abrir cerraduras y desactivar trampas.",
	"slat_EY_es": "OJO: Estos slats hacen referencia a la percepción, te permitirán superar desafios con los sentidos y encontrar cosas ocultas.",
	"slat_BT_es": "BOTA: Estos slats te permitirán moverte agilmente y ciertas habilidades como evadir daño.",
	"slat_SC_es": "PERGAMINO: Estos slats te permitirán manipular la magia para lanzar conjuros o superar trampas runicas.",
	"slat_SH_es": "ESCUDO: Estos slats te protegen del daño que puedas recibir.",
	"it_desc_short_sword_es": "ESPADA CORTA: Una pequeña espada bien afilada. Añade DOS ESPADA.",
	
	"msg_have_enemies_yet_es":"Aún hay enemigos, no puedes continuar sin destruirlos!",
	"msg_dont_have_slats_es":"No tienes SLATS suficientes!",
	"msg_dont_have_mov_es":"Ya agotaste todas tus ACCIONES!",
}

var images = {
	"@SW":"[font=res://assets/font/bbcode_font.tres][img=50]res://assets/dices/SW.png[/img][/font]",
	"@HP":"[font=res://assets/font/bbcode_font.tres][img=50]res://assets/bbimg/bb_hp.png[/img][/font]",
	"@GR":"[font=res://assets/font/bbcode_font.tres][img=50]res://assets/slats/GR.png[/img][/font]",
	"@MC":"[font=res://assets/font/bbcode_font.tres][img=50]res://assets/bbimg/gear.png[/img][/font]"
}

func get_text(code,vals = []):
	var lang_code = code+"_"+lang
	if !lang_code in texts: return "<"+lang_code+">"
	else: 
		var tx = texts[lang_code]
		for i in range(vals.size()): tx = tx.replace("#"+str(i+1),str(vals[i]))
		if "@" in tx: 
			for k in images.keys(): tx = tx.replace(k,images[k])
			return "[center]"+tx+"[/center]"
		else: return tx
		
