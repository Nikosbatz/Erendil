extends Button
var is_unlocked = false
var global_cooldown = false

func update_skill_slot(item: Inventory_item):
	if item:
		$CenterContainer/Panel/Item.texture = item.texture
	else:
		$CenterContainer/Panel/Item.texture = null
	
func unlock():
	is_unlocked = true
	$CenterContainer/Panel/unlocked_skill.visible = true
	
func lock_for_cooldown():
	$CenterContainer/Panel/unlocked_skill.visible = false
	global_cooldown = true
	
	
func unlock_from_cooldown():
	if is_unlocked and global_cooldown == true:
		$CenterContainer/Panel/unlocked_skill.visible = true
		global_cooldown = false
		
func lock_for_cast_cooldown():
	global_cooldown = false
	$CenterContainer/Panel/unlocked_skill.visible = false
	
	
func unlock_from_cast_cooldown():
	$CenterContainer/Panel/unlocked_skill.visible = true
