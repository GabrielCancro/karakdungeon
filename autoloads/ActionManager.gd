extends Node

var pj
var room
var def

var ACTION_LIST_NODE

signal end_action()

var ACTIONS = {
	"attack":{},
	"evade":{},
	"dissarm":{},
	"unlock":{},
	"force":{},
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
	ACTION_LIST_NODE.block()
	if has_method("run_action_"+ac_name):
		call("run_action_"+ac_name)
		DungeonManager.current_player.node.anim_action_start()
		yield(get_tree().create_timer(.2),"timeout")
		yield(self,"end_action")
		DungeonManager.force_update()
		DungeonManager.current_player.node.anim_action_end()
	ACTION_LIST_NODE.unblock()

func get_calculation(ac_name):
	if has_method("get_calculation_"+ac_name):
		return call("get_calculation_"+ac_name)
	return "-"
	
func check_action_attack(): return (def.type == "enemy")
func run_action_attack(): 
	def.hp -= 2
	yield(get_tree().create_timer(.5),"timeout")
	Effector.show_float_text("-2HP",room.position+Vector2(0,-100),"damage")
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action")

func check_action_evade():
	return (def.type == "enemy" && PlayerManager.current_player_have_dice("BT"))

func check_action_dissarm(): return (def.type == "trap")
func run_action_dissarm():
	var defUI = get_node("/root/Game/CLUI/DefianceUI")
	defUI.dif_test.roll()
	var result = yield(defUI.dif_test,"end_roll")
	yield(get_tree().create_timer(1),"timeout")
	if result=="FAIL": Effector.show_float_text("ACTIVATED!",room.position+Vector2(0,-100),"damage")
	elif result=="SUCCESS": 
		Effector.show_float_text("DISSARMED",room.position+Vector2(0,-100),"normal")
		DefianceManager.resolve_current_defiance()
	elif result=="NONE": Effector.show_float_text("NONE",room.position+Vector2(0,-100),"white")
	yield(get_tree().create_timer(.3),"timeout")
	emit_signal("end_action")

func check_action_unlock(): return (def.type == "door" or def.type == "chest")
func run_action_unlock():
	for dice in PlayerManager.get_current_player_dices():
		for i in range(def.req.size()):
			if def.req[i]==dice && !def.req_solved[i]: 
				def.req_solved[i] = true
				break
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action")

func check_action_force(): return (def.type == "door" or def.type == "chest")
func run_action_force():
	yield(get_tree().create_timer(.5),"timeout")
	randomize()
	if randi()%100<=70: 
		Effector.show_float_text("FORCE",room.position+Vector2(0,-100),"normal")
		for i in range(def.req_solved.size()):
			if !def.req_solved[i]:
				def.req.pop_at(i)
				def.req_solved.pop_at(i)
				break
	else: Effector.show_float_text("NONE",room.position+Vector2(0,-100),"white")
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action")

func get_calculation_force():
	return "-2HP"
