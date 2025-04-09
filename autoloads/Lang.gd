extends Node

var lang = "es"

var texts = {
	"df_enemy_es":"Te atacará si te mueves o realizas una acción.",
	"df_trap_es":"Se activa si atraviesas la habitación.",
	"df_block_es":"Destruyelo para poder pasar por aqui.",
	"df_door_es":"No puedes pasar por aquí hasta que abras el cerrojo.",
	"df_stairs_es":"Esta escalera lleva al siguiente nivel.",
	"df_fountain_es":"Esta fuente sanará hasta 2HP a quien beba de ella.",
	"df_chest_es":"Si logras abrirlo puedes obtener nuevos items.",
	
	"df_name_goblin_es":"Goblin",
	"df_name_rat_es":"Rata Gig.",
	"df_name_bat_es":"Murcielago",
	"df_name_trap_es":"Trampa",
	"df_name_door_es":"Puerta",
	"df_name_debris_es":"Escombros",
	"df_name_wchest_es":"Cofre",
	"df_name_chest_es":"Cofre",
	"df_name_stairs_es":"Escalera",
	"df_name_fountain_es":"Fuente",
	
	"ac_attack_es":"Causa entre 0 y 2 de daño, cada @SW añade un golpe extra.",
	"ac_clear_es":"Limpia entre 0 y 2, cada @SW y cada @HN añade un intento extra.",
	"ac_dissarm_es":"Cada @HN y cada @EY mejora la posibilidad de éxito.",
	"ac_unlock_es":"Completa los requisitos según los atributos actuales del personaje.",
	"ac_force_es":"20% de destruir el primer requisito, esté o no resuelto.",
	"ac_recover_es":"Curas tus puntos de vida (HP). Puede agotarse.",
	"ac_descend_es":"Necesitas la llave de este nivel y reunir a todos tus personajes aquí para poder descender.",
	
	"it_reload_es":"se recupera por nivel",
	"it_reload_not_es":"se destruye al gastarse",
	"it_old_dage_name_es":"DAGA VIEJA",
	"it_old_dage_desc_es":"Si no tiene ninguna @SW, ganas una @SW",
	"it_best_heart_name_es":"CORAZON DE BESTIA",
	"it_best_heart_desc_es":"Si tienes @SW@SW, te curas +2HP",
	"it_travel_boots_name_es":"BOTAS DE VIAJERO",
	"it_travel_boots_desc_es":"Si tienes @BT@BT, recuperas tu accion, recuperas todo tu movimiento, pero pierdes una @BT",
	"it_picklock_name_es":"Ganzuas",
	"it_picklock_desc_es":"Pierdes @EY pero ganas @HN@HN",
	"it_thief_knife_name_es":"Daga de ladron",
	"it_thief_knife_desc_es":"Pierdes @BT@HN y ganas @SW@SW",
	"it_healing_stuff_name_es":"Baston curativo",
	"it_healing_stuff_desc_es":"Pierdes @EY y recuperas +1HP",
	"it_battle_axe_name_es":"Hacha de batalla",
	"it_battle_axe_desc_es":"Si tienes @SW ganas un @SW extra",
	"it_heal_potion_name_es":"Pocion curativa",
	"it_heal_potion_desc_es":"Cura +1HP",
	"it_mind_potion_name_es":"Pocion de astucia",
	"it_mind_potion_desc_es":"Si tienes @EY ganas un @EY extra",
	

	"tuto_start_es":"Bienvenido a tu primer mazmorra!\nTe enseñaré lo básico para que puedas jugar..",
	"tuto_pjui_es":"En la parte inferior estan las fichas de tus personajes, allí verás sus atributos, vida y movimiento.",
	"tuto_dices_es":"Al comenzar cada turno, se arrojarán los dados de atributos de tus personajes, estos dados te dan ventaja en distintas acciónes.",
	
	"attr_SW_es":"@SW ESPADA: Fuerza, infliges mayor daño al atacar.",
	"attr_BT_es":"@BT BOTA: Agilidad, avanzas mas casillas que el resto y te da +10% chances de evadir daño.",
	"attr_HN_es":"@HN MANO: Maña, mayor facilidad para abrir cerrojos o desactivar trampas.",
	"attr_EY_es":"@EY OJO: Astucia, mayor facilidad para abrir cerrojos o desactivar trampas, tambien te da +25% chances de encontrar elementos ocultos.",

	"hint_key_es":"Necesitas encontrar la llave de este nivel, cuando la tengas podras bajar por la escalera al siguiente.",
	"hint_torch_es":"Cuando tu antorcha se termine, todos tus personajes reciben daño en cada turno.",
	"hint_hp_es":"HP: Son los puntos de golpe que resiste este desafío.",
	"hint_dif_es":"DIFICULTAD: Es el nivel de dificultad del desafío, generalmente se ve modificado por los atributos del personaje que interactua.",
	"hint_dm_es":"DAÑO: Es el daño que puede infligirte este desafío.",
	"hint_test_es":"TIRADA DE AZAR: Al interactuar se elige aleatoriamente una casilla de azar, si es [color=#FFFFAA]verde[/color], tienes exito, si es [color=#FF9999]rojo[/color] habras fallado.",
	"hint_reqs_es":"REQUISITOS: Debes completarlos utilizando los atributos de tus personajes para resolver este desafio.",
	"hint_reload_item_es":"RECARGABLE: Recuperas los usos de este item o habilidad al pasar al siguiente nivel.",
	"hint_items_es":"INVENTARIO: Los objetos son compartidos, cualquier personaje puede utilizarlos si cumple con su requisito.",
	"hint_show_tuto_es":"Mostrar tutorial.",

	"dice_neutral_es":"DADO NEUTRAL",
	"dice_fight_es":"DADO DE COMBATE",
	"dice_mind_es":"DADO DE ASTUCIA",
	"dice_agility_es":"DADO DE DESTREZA",
	"dice_custom_es":"DADO COMBINADO",
	
	"tx_hp_es":"HP: Indica la vitalidad del personaje, cuantos puntos de golpe puede resistir antes de morir.",
	"tx_mv_es":"MV: Indica cuantos movimientos puede realizar el personaje en cada turno.",
	
	"tuto_welcome_es":"[center][color=#f6ff88]BIENVENIDO[/color]\nTu grupo de aventureros ha descendido al primer nivel de este dungeon, debes explorarlo para encontrar la llave y poder bajar al siguiente nivel.",
	"tuto_pjs_es":"[center][color=#f6ff88]PERSONAJES Y MOVIMIENTO[/color]\nEn la parte inferior estan las fichas de tus personajes, puedes clickearlas o presionar [Q] para seleccionarlos y utilizar [W][A][S][D] para moverte por el dungeon.",
	"tuto_attr_es":"[center][color=#f6ff88]ATRIBUTOS[/color]\nAl inicio de cada turno tus personajes arrojan sus dados de atributos, dependiendo de los resultados obtendran ventaja para realizar unas u otras acciones.",
	"tuto_defiances_es":"[center][color=#f6ff88]DESAFIOS Y ACCIONES[/color]\nEncontraras diferentes desafios al explorar, como enemigos, escombros o trampas. Cada uno permite realizar diferentes acciones modificadas por los atributos de tus personajes.",
	"tuto_torch_es":"[center][color=#f6ff88]ANTORCHAS[/color]\nLas antorchas son la unica forma de mantenerte a salvo, cada turno se reducira su numero, si llega a cero todos tus personajes recibiran daño en cada turno, asegurate de que eso no suceda!",
	"tuto_end_es":"[center][color=#f6ff88]OBJETIVO[/color]\nEn el cuarto piso esta Gorok el troll, debes vencerlo para superar esta mision, buena suerte a tus aventureros!",

	"tx_skip_tutorial_es":"SALTAR TUTORIAL",
	"tx_close_tutorial_es":"CERRAR TUTORIAL",
	"tx_inventory_es": "INVENTARIO",

}

func get_help_attr_hint():
	return Lang.get_text("attr_SW")+"\n\n"+Lang.get_text("attr_BT")+"\n\n"+Lang.get_text("attr_HN")+"\n\n"+Lang.get_text("attr_EY")

func get_text(code,vals = []):
	var lang_code = code+"_"+lang
	if !lang_code in texts: return "<"+lang_code+">"
	else: 
		var tx = texts[lang_code]
		for i in range(vals.size()): tx = tx.replace("#"+str(i+1),str(vals[i]))
		return tx
