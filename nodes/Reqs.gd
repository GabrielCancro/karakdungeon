extends Control

var def

func set_defiance(_def):
	def = _def
	$Grid.add_constant_override("separation", 3-def.req.size()*3)
	for r in $Grid.get_children():
		var i = r.get_index()
		if i < def.req.size():
			r.texture = load("res://assets/dices/"+def.req[i]+".png")
			r.visible = true
			if !def.req_solved[i]: r.modulate = Color(.5,.5,.5,1)
			else: r.modulate = Color(1,1,1,1)
		else:
			r.visible = false

func all_complete():
	if !def: return false
	for solved in def.req_solved:
		if !solved: return false
	return true
