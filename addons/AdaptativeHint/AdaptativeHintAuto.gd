extends CanvasLayer

var HintPanel:Node
var currentNode

func _ready():
	HintPanel = preload("res://addons/AdaptativeHint/AdaptativeHint.tscn").instance()
	yield(get_node("/root"),"ready")
	get_node("/root").add_child(HintPanel)

func _on_hover_enter_area(node,text):
	if text && node && node!=currentNode: 
		currentNode = node
		HintPanel.show_panel(text)
	elif node==currentNode: 
		currentNode = null
		HintPanel.hide_panel()

### To use from your code 
### AdaptativeHintAuto.add_hint($node,"Example text about potions @POTION")
func add_hint(node:Node,text=""):
	if node.is_connected("mouse_entered",self,"_on_hover_enter_area"): 
		node.disconnect("mouse_entered",self,"_on_hover_enter_area")
		node.disconnect("mouse_exited",self,"_on_hover_enter_area")
	node.connect("mouse_entered",self,"_on_hover_enter_area",[node,text])
	node.connect("mouse_exited",self,"_on_hover_enter_area",[node,null])
	_on_hover_enter_area(node,false)
