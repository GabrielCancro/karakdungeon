extends Node

var pj
var room
var def

var ACTION_LIST_NODE

signal end_action()

var ACTIONS = {
	"attack":{},
	#"evade":{},
	"dissarm":{},
	"unlock":{},
	"force":{},
	"descend":{},
	"recover":{},
}

func get_room_actions():
	pj = DungeonManager.current_player
	room = DungeonManager.current_room
	def = null
	if room && "defiance" in room.data: def = room.data.defiance
	var ac_array = []
	for ac_name in ACTIONS.keys():
		if has_method("check_action_"+ac_name):
			if def && call("check_action_"+ac_name):
				ac_array.append(ac_name)
	return ac_array

func run_action(ac_name):
	Utils.disable_input(3)
	if has_method("run_action_"+ac_name):
		var keep_action = call("run_action_"+ac_name)
		DungeonManager.current_player.node.anim_action_start()
		yield(get_tree().create_timer(.2),"timeout")
		var result = yield(self,"end_action")
		DungeonManager.force_update()
		DungeonManager.current_player.node.anim_action_end()
		if result:
			PlayerManager.set_pj_attr("action",false)
			PlayerManager.set_pj_attr("mov",0)
	Utils.enable_input()

func get_bonif(ac_name):
	var am = 0
	if ac_name=="attack": am = PlayerManager.get_dice_amount("SW")
	elif ac_name=="unlock": am = PlayerManager.get_reqs_can_complete()
	elif ac_name=="dissarm": am = PlayerManager.get_dice_amount("HN") + PlayerManager.get_dice_amount("EY")
	if am!=0: return "("+str(am)+")"
	else: return ""

func check_action_attack(): return (def.type == "enemy") or (def.type == "block")
func run_action_attack(): 
	randomize()
	yield(get_tree().create_timer(.5),"timeout")
	for i in range(1+PlayerManager.get_dice_amount("SW")):
		var val = randi()%3
		def.hp -= val
		Effector.show_float_text("-"+str(val)+"HP",room.position+Vector2(0,-100+i*10),"damage")
		yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_action",true)

func check_action_evade():
	return (def.type == "enemy" && PlayerManager.current_player_have_dice("BT"))

func check_action_dissarm(): return (def.type == "trap")
func run_action_dissarm():
	var defUI = get_node("/root/Game/CLUI/DefianceUI")
	defUI.dif_test.roll()
	var result = yield(defUI.dif_test,"end_roll")
	yield(get_tree().create_timer(1),"timeout")
	if result=="FAIL": 
		Effector.show_float_text("ACTIVATED!",room.position+Vector2(0,-100),"damage")
		DefianceManager.activate_trap(def)
		yield(get_tree().create_timer(1.5),"timeout")
	elif result=="SUCCESS": 
		Effector.show_float_text("DISSARMED",room.position+Vector2(0,-100),"normal")
		DefianceManager.resolve_current_defiance()
	elif result=="NONE": Effector.show_float_text("NONE",room.position+Vector2(0,-100),"white")
	yield(get_tree().create_timer(.3),"timeout")
	emit_signal("end_action",true)


func check_action_unlock(): return (def.type == "door" or def.type == "chest")
func run_action_unlock():
	yield(get_tree().create_timer(.5),"timeout")
	for dice in PlayerManager.get_current_player_dices():
		for i in range(def.req.size()):
			if def.req[i]==dice && !def.req_solved[i]: 
				def.req_solved[i] = true
				break
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action",true)

func check_action_force(): return (def.type == "door" or def.type == "chest")
func run_action_force():
	yield(get_tree().create_timer(.5),"timeout")
	randomize()
	if randi()%100<=20: 
		Effector.show_float_text("FORCE",room.position+Vector2(0,-100),"normal")
		def.req.pop_at(0)
		def.req_solved.pop_at(0)
	else: Effector.show_float_text("NONE",room.position+Vector2(0,-100),"white")
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action",true)

func check_action_descend(): return (def.type == "stairs")
func run_action_descend():
	yield(get_tree().create_timer(.5),"timeout")
	if !DungeonManager.have_key:
		Effector.show_float_text("NEED LEVEL KEY",room.position+Vector2(0,-100),"white")
		emit_signal("end_action",false)
		return
	for p in PlayerManager.PLAYERS:
		if p.hp<=0: continue
		if p.x != room.data.x or p.y != room.data.y:
			Effector.show_float_text("NEED ALL PARTY",room.position+Vector2(0,-100),"white")
			emit_signal("end_action",false)
			return
	emit_signal("end_action",true)
	yield(get_tree().create_timer(1.5),"timeout")
	DungeonManager.goto_next_level()

func check_action_recover(): return (def.type == "fountain")
func run_action_recover():
	yield(get_tree().create_timer(.5),"timeout")
	if def.uses<=0:
		Effector.show_float_text("AGOTADO!",room.position+Vector2(0,-100),"white")
		emit_signal("end_action",false)
	elif pj.hp!=pj.hpm: 
		def.uses -= 1
		PlayerManager.heal_player(pj.id,2)
		if def.uses <= 0: def["def_sprite"].modulate = Color(.4,.4,.4,1)
		emit_signal("end_action",true)
	else: 
		Effector.show_float_text("FULL HP!",room.position+Vector2(0,-100),"white")
		emit_signal("end_action",false)
