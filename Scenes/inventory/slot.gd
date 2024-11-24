extends Panel

@onready var bg = $BG
@onready var itemSprite = $CenterContainer/Panel/Item


func update(item: Inventory_item):
	if !item:
		bg.frame = 0
		itemSprite.visible = false
	else:
		bg.frame = 1
		itemSprite.visible = true
		itemSprite.texture = item.texture
		print("Texture", itemSprite.texture)
		#itemSprite.scale = Vector2(10,10)
		
