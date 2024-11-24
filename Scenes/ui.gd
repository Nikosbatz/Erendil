extends CanvasLayer

@onready var emptyBar = $EmptyBarContainer
@onready var healthBar = $HealthBarContainer
@onready var inventory = $InventoryGUI
var healthLabel 





func _ready():
	inventory.close()
	healthLabel = $HealthLabel	
	healthLabel.text = "200/200"

#func setHealthBars(amount):
	
	#emptyBar.size.x += (emptyBar.size.x-100) * healthIncCoefficient
	#healthBar.size.x = emptyBar.size.x
	

func updateHealth(amount, totalHealth, currentHealth):
	
	print("updateHealth: ",(emptyBar.size.x * amount)/totalHealth)
	if currentHealth + amount <= 0 :
		healthLabel.text = str(0, "/", totalHealth)
		healthBar.size.x = 0
	elif currentHealth + amount >= totalHealth :
		healthLabel.text = str(totalHealth, "/", totalHealth)
		healthBar.size.x = emptyBar.size.x
	else :	
		
		healthBar.size.x += (emptyBar.size.x * amount)/totalHealth
		healthLabel.text = str(currentHealth + amount, "/", totalHealth)
	

func _input(event):
	if event.is_action_pressed("inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()

