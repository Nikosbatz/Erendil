extends CharacterBody2D


var attackBuff_scene : PackedScene = load("res://Scenes/attack_buff.tscn")



@export var inventory: Inventory
var global_pos_x
var global_pos_y
var speed:int = 115
var animationTree
var animationState
var animationPLayer
var state = MOVE
var meleeHitBox
var stats
var hurtBox
var attackType
var direction
var cast_cooldown = false
var buff_cooldown = false
var skill_unlocks = {5: "Fireball", 3: "IceSpike", 7: "AttackBuff"}
var skills = []

enum{
	MOVE,
	ATTACK,
	MELEE,
	SPELL_1,
	SPELL_2,
	SPELL_3,
	SPELL_4,
	ANIMATING
}


signal cast_spell(pos, spell, direction)
signal unlock_skill(name)
signal lock_skills_for_cd
signal unlock_skills_from_cd
signal unlock_buff_from_cd
signal lock_buff_for_cd
signal level_up

# Called when the node enters the scene tree for the first time.
func _ready():
	animationPLayer = $AnimationPlayer
	animationTree = $AnimationTree
	animationState = $AnimationTree.get("parameters/playback")
	meleeHitBox = $AttackMarker2D/MeleeHitBox
	$AttackMarker2D/MeleeHitBox/CollisionShape2D.disabled = true
	stats = $Stats
	hurtBox = $HurtBox
	#get_tree().call_group("ui", "setHealthBars", stats.totalHealth)
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	
	
	match state:
		MOVE:
			move_state()
		ATTACK:
			attack_state()
		ANIMATING:
			pass
		
	
func move_state():
	
	direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	
	
	if direction != Vector2.ZERO:
		meleeHitBox.knockback_direction = direction
		animationTree.set("parameters/Idle/blend_position", direction)
		animationTree.set("parameters/Walk/blend_position", direction)
		animationTree.set("parameters/Attack/blend_position", direction)
		animationState.travel("Walk")
		
	else:
		animationState.travel("Idle")
		
		
	move_and_slide()
	#global_pos_x = global_position.x
	#global_pos_y = global_position.y
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		attackType = MELEE
	elif Input.is_action_just_pressed("spell_1") and !cast_cooldown and skills.has("IceSpike"):
		state =  ATTACK
		attackType = SPELL_1
	elif Input.is_action_just_pressed("spell_2") and !cast_cooldown and skills.has("Fireball"):
		state =  ATTACK
		attackType = SPELL_2
	elif Input.is_action_just_pressed("spell_3") and !cast_cooldown and !buff_cooldown and skills.has("AttackBuff"):
		state =  ATTACK
		attackType = SPELL_3
	elif Input.is_action_just_pressed("use_item_1"):
		inventory.use_item()
		stats.currentHealth += 30
		get_tree().call_group("ui", "updateHealth", 30, stats.totalHealth, stats.currentHealth)
		
	
	
	
func attack_state():
	
	
	match attackType:
		MELEE:
			animationState.travel("Attack")
			$HitStream.play()
			
		SPELL_1:
			cast_spell.emit($AttackMarker2D/SpellMarker2D.global_position, "spell_1", animationTree.get("parameters/Attack/blend_position"))
			animationState.travel("Attack")
			cast_cooldown = true
			lock_skills_for_cd.emit()
			$CooldownTimer.start()
			$IceSpikeStream.play()
			state = ANIMATING
		SPELL_2:
			cast_spell.emit($AttackMarker2D/SpellMarker2D.global_position, "spell_2", animationTree.get("parameters/Attack/blend_position"))
			animationState.travel("Attack")
			cast_cooldown = true
			lock_skills_for_cd.emit()
			$CooldownTimer.start()
			$FireBallStream.play()
			state = ANIMATING
		SPELL_3:
			var attackBuff = attackBuff_scene.instantiate()
			$Buffs.add_child(attackBuff)
			attackBuff.connect("duration_ended", _on_attack_buff_duration_ended)
			buff_cooldown = true
			lock_skills_for_cd.emit()
			lock_buff_for_cd.emit()
			$CooldownTimer.start()
			attackBuff.casted()
			stats.attackDmg += stats.attackDmg*0.5
			$BuffStream.play()
			state = MOVE
	
				
	
	
func attack_anim_finished():
	state = MOVE
	
	
func gain_exp(value):
	stats.gain_exp(value)
	
	
		

func _on_hurt_box_area_entered(area):
	
	if area.has_method("collect"):
		area.collect(inventory)
		$ItemCollectStream.play()
		
	else:
		get_tree().call_group("ui", "updateHealth", -area.attackDmg, stats.totalHealth, stats.currentHealth)
		stats.currentHealth -= area.attackDmg
		$HurtBoxStream.play()
		print("currentHealth: ", stats.currentHealth)
		


func _on_stats_zero_health():
	$GameOverStream.play()
	queue_free()


func _on_cooldown_timer_timeout():
	cast_cooldown = false
	unlock_skills_from_cd.emit()
	


func _on_stats_level_up():
	level_up.emit(stats.level)
	$LevelUpStream.play()
	$AttackMarker2D/MeleeHitBox.attackDmg = stats.attackDmg
	if skill_unlocks.get(stats.level):
		unlock_skill.emit(skill_unlocks.get(stats.level))
		skills.append(skill_unlocks.get(stats.level))
	
func _on_attack_buff_duration_ended():
	stats.attackDmg -= stats.attackDmg*0.3
	buff_cooldown = false
	unlock_buff_from_cd.emit()
	
	
