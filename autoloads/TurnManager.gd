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
	emit_signal("end_reaction")

func on_leave_room():
	yield(get_tree().create_timer(.02),"timeout")
	emit_signal("end_reaction")

func on_post_action():
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
