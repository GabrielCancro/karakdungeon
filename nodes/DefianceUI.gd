extends ColorRect

var defiance
var dif_test

func _ready():
	dif_test = $TestRnd
	DungeonManager.connect("change_room",self,"update")

func update():
	#print("DEFIANCE UI UPDATE")
	$TestRnd.visible = false
	var room = DungeonManager.current_room
	if room && "defiance" in room.data: defiance = room.data["defiance"]
	else: defiance = null
	
	if defiance:
		if "hp" in defiance && defiance.hp<=0: 
			DefianceManager.resolve_current_defiance()
			return
		if "prg" in defiance && defiance.prg>=defiance.prgm: 
			DefianceManager.resolve_current_defiance()
			return
	
	if defiance:
		$Sprite.texture = load("res://assets/defiances/df_"+defiance.name+".png")
		$lb_name.text = defiance.name
		$lb_stats.text = ""
		if "hp" in defiance: $lb_stats.text += " HP:"+str(defiance.hp)+"/"+str(defiance.hpm)+" "
		if "prg" in defiance: $lb_stats.text += " PRG:"+str(defiance.prg)+"/"+str(defiance.prgm)+" "
		if "dif" in defiance: 
			$lb_stats.text += " DIF:<"+str(defiance.dif)+">"+"          "
			$TestRnd.visible = true
			$TestRnd.set_dif(defiance.dif)
		if "dam" in defiance: $lb_stats.text += " DAM:<"+str(defiance.dam)+">"+" "
	
	visible = (defiance!=null)
