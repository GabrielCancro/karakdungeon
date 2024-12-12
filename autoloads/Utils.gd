extends Node

func set_zindex(node, delay=0):
	if delay>0: yield(get_tree().create_timer(delay),"timeout")
	node.z_index = 500+node.global_position.y/20
	print(node.name,"  zindex ",node.z_index)
