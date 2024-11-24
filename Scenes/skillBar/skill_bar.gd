extends NinePatchRect


@onready var inventory: Inventory = preload("res://Scenes/inventory/items/PlayerInventory.tres")
@onready var hotBarSlots = $HotBarSlots.get_children()
@onready var skillSlots = $SkillBarSlots.get_children()


func _ready():
	inventory.updated.connect(update)
	
	update()

func update():
	for i in range(hotBarSlots.size()):
		hotBarSlots[i].update_skill_slot(inventory.items[i])
		
func unlock_skill(name):
	
	for slot in $SkillBarSlots.get_children():
		if slot.name == name:
			slot.unlock()
			
func lock_skills_for_cd():
	for slot in skillSlots:
		slot.lock_for_cooldown()
		
func unlock_skills_from_cd():
	for slot in skillSlots:
		slot.unlock_from_cooldown()


func unlock_buff_from_cd():
	$SkillBarSlots/AttackBuff.unlock_from_cast_cooldown()
	
func lock_buff_for_cd():
	$SkillBarSlots/AttackBuff.lock_for_cast_cooldown()
