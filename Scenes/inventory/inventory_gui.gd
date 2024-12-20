extends Control

var isOpen: bool = false
signal opened
signal closed
@onready var inventory: Inventory = preload("res://Scenes/inventory/items/PlayerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()


func _ready():
	inventory.updated.connect(update)
	update()

func update():
	for i in range(min(inventory.items.size(), slots.size())):
		slots[i].update(inventory.items[i])

func open():
	visible = true
	isOpen = true
	opened.emit()
	
func close():
	visible = false
	isOpen = false
	closed.emit()
	
