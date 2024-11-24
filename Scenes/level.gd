extends Node2D


var rng := RandomNumberGenerator.new()
var iceSpike_scene : PackedScene = load("res://Scenes/ice_spike.tscn")
var fireBall_scene : PackedScene = load("res://Scenes/fire_ball.tscn")
var attackBuff_scene : PackedScene = load("res://Scenes/attack_buff.tscn")
var bat_scene : PackedScene = load("res://Scenes/bat.tscn")
var mole_scene : PackedScene = load("res://Scenes/mole.tscn")
var axolot_scene : PackedScene = load("res://Scenes/axolot.tscn")
var heart_scene : PackedScene = load("res://Scenes/heart_red.tscn")

var axolotCap = 10
var axolotLiving
var axolotAreaStart = Vector2(1100, 0)
var axolotAreaEnd = Vector2(1750, 250)
var moleCap = 10
var moleLiving
var moleAreaStart = Vector2(1900, 250)
var moleAreaEnd = Vector2(2600, 650)
var batCap = 10
var batLiving
var batAreaStart = Vector2(100, 100)
var batAreaEnd = Vector2(800, 300)
var heartCap = 35
var heartLiving
var heartAreaStart = Vector2(1350, 1050)
var heartAreaEnd = Vector2(2300, 1700)

@onready var skillBar = $UI/SkillBar
@onready var playerLevelLabel = $UI/PlayerLevelLabel/Label/Label2

enum{
	MELEE,
	SPELL_1,
	SPELL_2
}



# Called when the node enters the scene tree for the first time.
func _ready():
	
	
	
	for i in axolotCap:
		var axolot = axolot_scene.instantiate()
		$Enemies/Axolots.add_child(axolot)
		var spawn_point = valid_spawn_point(axolotAreaStart.x, axolotAreaEnd.x, axolotAreaStart.y, axolotAreaEnd.y)
		axolot.position = spawn_point
		
		
	for i in moleCap:
		var mole = mole_scene.instantiate()
		$Enemies/Moles.add_child(mole)
		var spawn_point = valid_spawn_point(moleAreaStart.x, moleAreaEnd.x, moleAreaStart.y, moleAreaEnd.y)
		mole.position = spawn_point
		
	for i in batCap:
		var bat = bat_scene.instantiate()
		$Enemies/Bats.add_child(bat)
		var spawn_point = valid_spawn_point(batAreaStart.x, batAreaEnd.x, batAreaStart.y, batAreaEnd.y)
		bat.position = spawn_point
	
	for i in heartCap:
		var heart = heart_scene.instantiate()
		$Enemies/Hearts.add_child(heart)
		#print("HEART Section")
		var spawn_point = valid_spawn_point(heartAreaStart.x, heartAreaEnd.x, heartAreaStart.y, heartAreaEnd.y)
		heart.position = spawn_point
		




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_cast_spell(pos, spell, direction):
	
	skillBar.lock_skills_for_cd()
	if spell == "spell_1":
		var iceSpike = iceSpike_scene.instantiate()
		iceSpike.set_cast_direction(direction)
		iceSpike.position = pos
		iceSpike.attackDmg = $Player.stats.attackDmg * 1.5
		$Spells.add_child(iceSpike)
		
	elif spell == "spell_2":
		var fireBall = fireBall_scene.instantiate()
		fireBall.set_cast_direction(direction)
		fireBall.position = pos
		fireBall.attackDmg = $Player.stats.attackDmg * 2
		$Spells.add_child(fireBall)
	
		
	


func valid_spawn_point(areaStartX, areaEndX, areaStartY, areaEndY):
	while true:
		var random_pos_x = rng.randi_range(areaStartX, areaEndX)
		var random_pos_y = rng.randi_range(areaStartY, areaEndY)
		var random_point = Vector2(random_pos_x, random_pos_y)
		
		var cell_coord = $TileMap2.local_to_map(random_point)
		
		#print(cell_coord)
		var cell_buildings = $TileMap2.get_cell_tile_data(2, cell_coord)
		var cell_mountains = $TileMap2.get_cell_tile_data(1, cell_coord)
		
		
		if !cell_buildings and !cell_mountains:
			
			#print("VALID SPAWN POINT")
			return random_point 
		else:
			#print("INVALID SPAW POINT: ", random_point)
			pass


func _on_enemy_respawn_timer_timeout():
	
	for enemy_type in $Enemies.get_children():
		
		if enemy_type.name == "Bats":
			for i in range (0, batCap-enemy_type.get_child_count()):
					var bat = bat_scene.instantiate()
					$Enemies/Bats.add_child(bat)
					var spawn_point = valid_spawn_point(batAreaStart.x, batAreaEnd.x, batAreaStart.y, batAreaEnd.y)
					bat.position = spawn_point
					
		
		elif enemy_type.name == "Axolots":
			for i in range (0, axolotCap-enemy_type.get_child_count()):
					var axolot = axolot_scene.instantiate()
					$Enemies/Axolots.add_child(axolot)
					var spawn_point = valid_spawn_point(axolotAreaStart.x, axolotAreaEnd.x, axolotAreaStart.y, axolotAreaEnd.y)
					axolot.position = spawn_point
		
		elif enemy_type.name == "Moles":
			for i in range (0, moleCap-enemy_type.get_child_count()):
					var mole = mole_scene.instantiate()
					$Enemies/Moles.add_child(mole)
					var spawn_point = valid_spawn_point(moleAreaStart.x, moleAreaEnd.x, moleAreaStart.y, moleAreaEnd.y)
					mole.position = spawn_point
		
		elif enemy_type.name == "Hearts":
			for i in range (0, heartCap-enemy_type.get_child_count()):
				var heart = heart_scene.instantiate()
				$Enemies/Hearts.add_child(heart)
				var spawn_point = valid_spawn_point(heartAreaStart.x, heartAreaEnd.x, heartAreaStart.y, heartAreaEnd.y)
				heart.position = spawn_point
					
		

func _on_inventory_gui_closed():
	get_tree().paused = false


func _on_inventory_gui_opened():
	get_tree().paused = true


func _on_player_unlock_skill(name):
	skillBar.unlock_skill(name)


func _on_player_lock_skills_for_cd():
	skillBar.lock_skills_for_cd()


func _on_player_unlock_skills_from_cd():
	skillBar.unlock_skills_from_cd()


func _on_player_unlock_buff_from_cd():
	skillBar.unlock_buff_from_cd()
	

func _on_player_lock_buff_for_cd():
	skillBar.lock_buff_for_cd()


func _on_player_level_up(level):
	playerLevelLabel.text = str(level)







