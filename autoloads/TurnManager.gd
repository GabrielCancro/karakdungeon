extends Node

signal end_reaction()

func on_pre_move():
	yield(get_tree().create_timer(.02),"timeout")
	var def = DungeonManager.get_room_defiance()
	if def && def.type=="enemy": 
		enemy_attack(def,DungeonManager.current_player)
		yield(get_tree().create_timer(.7),"timeout")
	emit_signal("end_reaction")

func on_across_room():
	yield(get_tree().create_timer(.02),"timeout")
	var def = DungeonManager.get_room_defiance()
	if def && def.type=="trap": 
		DefianceManager.activate_trap(def)
		yield(get_tree().create_timer(1.5),"timeout")
	emit_signal("end_reaction")

func on_leave_room():
	yield(get_tree().create_timer(.02),"timeout")
	emit_signal("end_reaction")

func on_post_action():
	yield(get_tree().create_timer(.7),"timeout")
	on_pre_move()
#	yield(get_tree().create_timer(.5),"timeout")
#	var def = DungeonManager.get_room_defiance()
#	if def && def.type=="enemy": 
#		enemy_attack(def,DungeonManager.current_player)
#		yield(get_tree().create_timer(.7),"timeout")
#	emit_signal("end_reaction")

func enemy_attack(def,pj):
	Effector.scale_boom(def.def_sprite)
	Effector.move_to_yoyo(def.def_sprite, Vector2(pj.h,pj.v)*50)
	print(pj)
	yield(get_tree().create_timer(.3),"timeout")
	PlayerManager.damage_current_player(1)

func end_turn():
	get_node("/root/Game/CLUI/ActionList").visible = false
	for p in PlayerManager.PLAYERS:
		if p.hp>0:
			p.mov = p.movm
			p.action = true
			p.ui.roll_dices()
		else:
			p.mov = 0
			p.action = false
		p.ui.updateUI()
	yield(get_tree().create_timer(2),"timeout")
	PlayerManager.change_player(DungeonManager.current_player.id)
	get_node("/root/Game/CLUI/ActionList").visible = true
