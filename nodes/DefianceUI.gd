extends ColorRect

var defiance
var dif_test

func _ready():
	dif_test = $TestRnd
	#on_hint_hover(false)
	#$HintButton.connect("mouse_entered",self,"on_hint_hover",[true])
	#$HintButton.connect("mouse_exited",self,"on_hint_hover",[false])
	DungeonManager.connect("change_room",self,"update")
	AdaptativeHintAuto.add_hint($hp,Lang.get_text("hint_hp"))
	AdaptativeHintAuto.add_hint($dif,Lang.get_text("hint_dif"))
	AdaptativeHintAuto.add_hint($dm,Lang.get_text("hint_dm"))
	AdaptativeHintAuto.add_hint($TestRnd/Button,Lang.get_text("hint_test"))
	AdaptativeHintAuto.add_hint($Reqs/Button,Lang.get_text("hint_reqs"))
	$ab/AnimationPlayer.play("idel")

func update():
	#print("DEFIANCE UI UPDATE")
	$TestRnd.visible = false
	$Reqs.visible = false
	var room = DungeonManager.current_room
	if room && "defiance" in room.data: defiance = room.data["defiance"]
	else: defiance = null
	if defiance && "hide" in defiance && defiance.hide: defiance = null
	
	if defiance:
		$Sprite.texture = load("res://assets/defiances/df_"+defiance.name+".png")
		$lb_name.text = Lang.get_text("df_name_"+defiance.name)
		$desc/lb.text = Lang.get_text("df_"+defiance.type)
		$lb_stats.text = ""
		#if "hp" in defiance: $lb_stats.text += " HP:"+str(defiance.hp)+"/"+str(defiance.hpm)+" "
		$hp.visible = ("hp" in defiance)
		if $hp.visible: $hp/lb.text = str(defiance.hp)
		if "uses" in defiance: $lb_stats.text += " USES: "+str(defiance.uses)
		if "prg" in defiance: $lb_stats.text += " PRG:"+str(defiance.prg)+"/"+str(defiance.prgm)+" "
		$dif.visible = ("dif" in defiance)
		if $dif.visible: 
			var am = 0
			if defiance.type=="trap": 
				am = PlayerManager.get_dice_amount("HN") + PlayerManager.get_dice_amount("EY")
			$dif/lb.text = str(defiance.dif - am)
			$TestRnd.set_dif(defiance.dif - am)
			$TestRnd.visible = true
		if "req" in defiance:
			$Reqs.set_defiance(defiance)
			$Reqs.visible = true
		$dm.visible = ("dam" in defiance)
		if $dm.visible: $dm/lb.text = str(defiance.dam)
		$ab.visible = ("ability" in defiance)
		if $ab.visible: AdaptativeHintAuto.add_hint($ab,Lang.get_text("ab_"+defiance["ability"]))
		#if "dam" in defiance: $lb_stats.text += " DAM:<"+str(defiance.dam)+">"+" "
	
		if defiance && !"checked" in defiance && check_solved(): 
			defiance["checked"]=true
			DefianceManager.resolve_current_defiance()
	
	visible = (defiance!=null)

func check_solved():
	if "hp" in defiance && defiance.hp<=0: return true
	if "prg" in defiance && defiance.prg>=defiance.prgm: return true
	#if "dif" in defiance && $TestRnd.result == "SUCCESS": return true
	if "req" in defiance && $Reqs.all_complete(): return true

func on_hint_hover(val):
	$lb_desc.visible = val
