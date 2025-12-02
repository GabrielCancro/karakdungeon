extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.connect("button_down",self,"save_game")

func save_game():
	print("########## ROOMS #############")
	#for room in get_node("/root/Game/Map").get_children():
		#print(room.data)
		
	print("########## MAP #############")
	#for roomMapKey in DungeonManager.map:
		#print(DungeonManager.map[roomMapKey])

	print("########## PLAYERS #############")
	for playerData in PlayerManager.PLAYERS:
		print(playerData)
	
	print("########## ITEMS #############")
	#for itemData in ItemManager.PARTY_ITEMS:
	for itemNode in get_node("/root/Game/CLUI/ItemList/Items").get_children():
		print(itemNode.data)
	
func load_game():
	pass
