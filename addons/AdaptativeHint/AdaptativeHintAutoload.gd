extends CanvasLayer

var HintPanel:Node

func _ready():
	HintPanel = preload("res://addons/AdaptativeHint/AdaptativeHint.tscn").instance()
	yield(get_node("/root"),"ready")
	get_node("/root").add_child(HintPanel)

func _process(delta):
	pass

func add_hint(node:Node,text=""):
	print("ADD HINT TO NODE --> ",node.name)
	node.connect("mouse_entered",self,"_on_hover_enter_area",[node,text])
	node.connect("mouse_exited",self,"_on_hover_enter_area",[node,null])
	_on_hover_enter_area(node,false)

func _on_hover_enter_area(node,text):
	if text: HintPanel.show_panel(text)
	else: HintPanel.hide_panel()
