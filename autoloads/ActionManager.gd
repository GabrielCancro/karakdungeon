extends Node

var pj
var room
var def

var ACTION_LIST_NODE

signal end_action()

var ACTIONS = {
	"attack":{},
	#"evade":{},
	"clear":{},
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
	if "hide" in def && def.hide: return ac_array
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
	var am = "-"
	if ac_name=="attack": am = "x"+str(PlayerManager.get_dice_amount("SW")+1)
	if ac_name=="clear": am = "x"+str(PlayerManager.get_dice_amount("SW")+PlayerManager.get_dice_amount("HN")+1)
	elif ac_name=="unlock": am = "x"+str(PlayerManager.get_reqs_can_complete())
	elif ac_name=="dissarm": am = "+"+str(PlayerManager.get_dice_amount("HN") + PlayerManager.get_dice_amount("EY"))
	elif ac_name=="force": am = "20%"
	return am

func check_action_attack(): return (def.type == "enemy")
func run_action_attack(): 
	randomize()
	yield(get_tree().create_timer(.5),"timeout")
	var defUI = get_node("/root/Game/CLUI/DefianceUI")
	for i in range(1+PlayerManager.get_dice_amount("SW")):
		var val = randi()%3
		def.hp -= val
		Effector.show_float_text("-"+str(val)+"HP",room.position+Vector2(0,-100+i*10),"damage")
		LittleGS.play_sound("hit")
		defUI.update()
		Effector.move_to_yoyo(pj.node,(pj.node.global_position-pj.node.get_dest_pos())*0.5)
		yield(get_tree().create_timer(.7),"timeout")
		if def.hp<=0: break
	emit_signal("end_action",true)

func check_action_clear(): return (def.type == "block")
func run_action_clear(): 
	randomize()
	yield(get_tree().create_timer(.3),"timeout")
	var defUI = get_node("/root/Game/CLUI/DefianceUI")
	for i in range(1+PlayerManager.get_dice_amount("SW")+PlayerManager.get_dice_amount("HN")):
		var val = randi()%3
		def.hp -= val
		Effector.show_float_text("-"+str(val)+"HP",room.position+Vector2(0,-100+i*10),"damage")
		LittleGS.play_sound("hit_rock")
		defUI.update()
		Effector.move_to_yoyo(pj.node,(pj.node.global_position-pj.node.get_dest_pos())*0.5)
		yield(get_tree().create_timer(.5),"timeout")
		if def.hp<=0: break
	emit_signal("end_action",true)

func check_action_evade():
	return (def.type == "enemy" && PlayerManager.current_player_have_dice("BT"))

func check_action_dissarm(): return (def.type == "trap")
func run_action_dissarm():
	var defUI = get_node("/root/Game/CLUI/DefianceUI")
	defUI.dif_test.roll()
	LittleGS.play_sound("lockpick1")
	var result = yield(defUI.dif_test,"end_roll")
	yield(get_tree().create_timer(1),"timeout")
	if result=="FAIL": 
		Effector.show_float_text("ACTIVATED!",room.position+Vector2(0,-100),"damage")
		DefianceManager.activate_trap(def)
		LittleGS.play_sound("lock2")
		yield(get_tree().create_timer(1.5),"timeout")
	elif result=="SUCCESS": 
		LittleGS.play_sound("unlock3")
		Effector.show_float_text("DISSARMED",room.position+Vector2(0,-100),"normal")
		DefianceManager.resolve_current_defiance()
	elif result=="NONE": 
		LittleGS.play_sound("lock2")
		Effector.show_float_text("NONE",room.position+Vector2(0,-100),"white")
	yield(get_tree().create_timer(.3),"timeout")
	emit_signal("end_action",true)


func check_action_unlock(): return (def.type == "door" or def.type == "chest")
func run_action_unlock():
	yield(get_tree().create_timer(.5),"timeout")
	var have_unlocks = false
	for dice in PlayerManager.get_current_player_dices():
		for i in range(def.req.size()):
			if def.req[i]==dice && !def.req_solved[i]: 
				def.req_solved[i] = true
				have_unlocks = true
				break
	if have_unlocks: 
		LittleGS.play_sound("lockpick1")
		yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action",have_unlocks)

func check_action_force(): return (def.type == "door" or def.type == "chest")
func run_action_force():
	yield(get_tree().create_timer(.5),"timeout")
	randomize()
	if randi()%100<=20: 
		Effector.show_float_text("FORCE",room.position+Vector2(0,-100),"normal")
		var index = randi()%def.req.size()
		def.req.pop_at(index)
		def.req_solved.pop_at(index)
	else: Effector.show_float_text("NONE",room.position+Vector2(0,-100),"white")
	LittleGS.play_sound("hit_door",70)
	yield(get_tree().create_timer(.5),"timeout")
	emit_signal("end_action",true)

func check_action_descend(): return (def.type == "stairs")
func run_action_descend():
	yield(get_tree().create_timer(.5),"timeout")
	if !DungeonManager.have_key:
		Effector.show_float_text(Lang.get_text("tx_need_key"),room.position+Vector2(0,-100),"white")
		LittleGS.play_sound("fail",80)
		emit_signal("end_action",false)
		return
	for p in PlayerManager.PLAYERS:
		if p.hp<=0: continue
		if p.x != room.data.x or p.y != room.data.y:
			Effector.show_float_text(Lang.get_text("tx_need_party"),room.position+Vector2(0,-100),"white")
			LittleGS.play_sound("fail",80)
			emit_signal("end_action",false)
			return
	emit_signal("end_action",true)
	yield(get_tree().create_timer(.4),"timeout")
	Utils.show_popup("transition1")
	yield(get_tree().create_timer(1),"timeout")
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
