extends Area2D

@export var item_resource: Inventory_item

func collect(inventory: Inventory):
	inventory.insert(item_resource)
	queue_free()
