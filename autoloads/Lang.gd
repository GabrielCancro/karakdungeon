extends Node

var lang = "es"

var texts = {
	"df_enemy_es":"Te atacará si te mueves o realizas una acción.",
	"df_trap_es":"Se activa si atraviesas la habitación.",
	"df_block_es":"Destruyelo para poder pasar por aqui.",
	"df_door_es":"No puedes pasar por aquí hasta que abras el cerrojo.",
	"df_stairs_es":"Esta escalera lleva al siguiente nivel.",
	"df_fountain_es":"Esta fuente sanará hasta 2HP a quien beba de ella.",
	
	"ac_attack_es":"Causa entre 0 y 2 de daño, cada @SW añade un golpe extra.",
	"ac_dissarm_es":"Cada @HN y cada @EY mejora la posibilidad de éxito.",
	"ac_unlock_es":"Completa los requisitos según los atributos actuales del personaje.",
	"ac_force_es":"20% de destruir el primer requisito, esté o no resuelto.",
	"ac_recover_es":"Curas tus puntos de vida (HP). Puede agotarse.",
	"ac_descend_es":"Necesitas la llave de este nivel y reunir a todos tus personajes aquí para poder descender.",
	
	"it_old_dage_name_es":"DAGA VIEJA",
	"it_old_dage_desc_es":"Si no tiene ninguna @SW, ganas una @SW",
	"it_best_heart_name_es":"CORAZON DE BESTIA",
	"it_best_heart_desc_es":"Si tienes @SW@SW, te curas +2HP",
	"it_travel_boots_name_es":"BOTAS DE VIAJERO",
	"it_travel_boots_desc_es":"Si tienes @BT@BT, recuperas tu accion, recuperas todo tu movimiento, pero pierdes una @BT",

	"tuto_start_es":"Bienvenido a tu primer mazmorra!\nTe enseñaré lo básico para que puedas jugar..",
	"tuto_pjui_es":"En la parte inferior estan las fichas de tus personajes, allí verás sus atributos, vida y movimiento.",
	"tuto_dices_es":"Al comenzar cada turno, se arrojarán los dados de atributos de tus personajes, estos dados te dan ventaja en distintas acciónes.",
	
	"attr_SW_es":"@SW ESPADA: Fuerza de combate, otorga mayor daño de ataque.",
	"attr_BT_es":"@BT BOTA: Agilidad de movimiento, te permite esquivar y avanzar mas casillas que el resto.",
	"attr_HN_es":"@HN MANO: Maña, mayor facilidad para abrir cerrojos o desactivar trampas.",
	"attr_EY_es":"@EY OJO: Percepcion y astucia, mayor facilidad para encontrar secretos y resolver enigmas.",

	"hint_key_es":"Necesitas encontrar la llave de este nivel, cuando la tengas podras bajar por la escalera al siguiente.",
	"hint_torch_es":"Cuando tu antorcha se termine, todos tus personajes reciben un punto de daño.",
	"hint_hp_es":"HP: Son los puntos de golpe que resiste este desafío.",
	"hint_dif_es":"DIFICULTAD: Es el nivel de dificultad del desafío, generalmente se ve modificado por los atributos del personaje que interactua.",
	"hint_dm_es":"DAÑO: Es el daño que puede infligirte este desafío.",
	"hint_test_es":"TIRADA DE AZAR: Al interactuar se elige aleatoriamente una casilla de azar, si es [color=#FFFFAA]verde[/color], tienes exito, si es [color=#FF9999]rojo[/color] habras fallado.",
	"hint_reqs_es":"DAÑO: Es el daño que puede infligirte este desafío.",
	"hint_reload_item_es":"RECARGABLE: Recuperas los usos de este item o habilidad al pasar al siguiente nivel.",
	
	"dice_neutral_es":"DADO NEUTRAL",
	"dice_fight_es":"DADO DE COMBATE",
	"dice_mind_es":"DADO DE ASTUCIA",
	"dice_agility_es":"DADO DE DESTREZA",
	"dice_custom_es":"DADO COMBINADO",
}


func get_text(code,vals = []):
	var lang_code = code+"_"+lang
	if !lang_code in texts: return "<"+lang_code+">"
	else: 
		var tx = texts[lang_code]
		for i in range(vals.size()): tx = tx.replace("#"+str(i+1),str(vals[i]))
		return tx
