extends Node

signal end_reaction()

func on_pre_move():
	Utils.disable_input(0.1)
	yield(get_tree().create_timer(.02),"timeout")
	var def = DungeonManager.get_room_defiance()
	if def && def.type=="enemy": 
		enemy_attack(def,DungeonManager.current_player)
		Utils.disable_input(.7)
		yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_reaction")

func on_across_room():
	Utils.disable_input(0.1)
	yield(get_tree().create_timer(.02),"timeout")
	var def = DungeonManager.get_room_defiance()
	if def && def.type=="trap": 
		DefianceManager.activate_trap(def)
		Utils.disable_input(1.5)
		yield(get_tree().create_timer(1.5),"timeout")
	emit_signal("end_reaction")

func on_leave_room():
	Utils.disable_input(0.1)
	yield(get_tree().create_timer(.02),"timeout")
	emit_signal("end_reaction")

func on_post_action():
	Utils.disable_input(.8)
	yield(get_tree().create_timer(.7),"timeout")
	on_pre_move()
#	yield(get_tree().create_timer(.5),"timeout")
#	var def = DungeonManager.get_room_defiance()
#	if def && def.type=="enemy": 
#		enemy_attack(def,DungeonManager.current_player)
#		yield(get_tree().create_timer(.7),"timeout")
#	emit_signal("end_reaction")

func enemy_attack(def,pj):
	Utils.disable_input(.5)
	Effector.scale_boom(def.def_sprite)
	Effector.move_to_yoyo(def.def_sprite, Vector2(pj.h,pj.v)*50)
	print(pj)
	yield(get_tree().create_timer(.3),"timeout")
	PlayerManager.damage_current_player(1)

func end_turn():
	Utils.disable_input(2)
	get_node("/root/Game/CLUI/ActionList").visible = false
	for p in PlayerManager.PLAYERS:
		p.mov = 0
		p.action = false
		if p.hp>0:
			p.action = true
			p.ui.roll_dices()
		p.ui.updateUI()
	yield(get_tree().create_timer(2),"timeout")
	for p in PlayerManager.PLAYERS:
		p.mov = p.movm
		for d in p.ui.get_dices(): if d=="BT": p.mov += 1
		p.ui.updateUI()
	PlayerManager.change_player(DungeonManager.current_player.id)
	get_node("/root/Game/CLUI/ActionList").visible = true
