extends Resource

class_name Inventory

@export var items: Array[Inventory_item]
signal updated

func insert(item: Inventory_item):
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			print("Item Texture: ", item.texture)
			break
		print("Inventory full!")
	print("updated")
	updated.emit()
	
func use_item():
	print("used")
	if items[0] != null:
		if items[0].name == "HealthPot":
			for i in range (1, items.size()):
				if items[i] != null:
					items[i-1] = items[i]
				else:
					items[i-1] = null
	updated.emit()  
