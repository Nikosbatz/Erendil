extends Node

@export var totalHealth  = 100
@export var attackDmg = 20
@export var exp_value = 100

var level = 1
var experience = 0
var experience_cap = 100



	

signal level_up
signal zero_health
@export var currentHealth = totalHealth:
	get:
		return currentHealth
	set(value):
		#print(value)
		if value <= totalHealth:
			currentHealth = value
		else:
			currentHealth = totalHealth
		#print("currentHealth: " , currentHealth)
		if currentHealth <= 0:
			emit_signal("zero_health") 


func gain_exp(value):
		experience += value
		if experience >= experience_cap:
			levelUp()
			
			
func levelUp():
	experience -= experience_cap
	level += 1
	experience_cap *= 1.2
	level_up.emit()
	totalHealth += totalHealth * level/100
	currentHealth = totalHealth
	attackDmg += 10
	get_tree().call_group("ui", "updateHealth", totalHealth, totalHealth, currentHealth)
	

