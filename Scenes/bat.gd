extends CharacterBody2D

const EnemyDeathEffect = preload("res://Scenes/enemy_death_effect.tscn")
const SPEED = 80
@onready var stats = $Stats
@onready var animatedSprite = $AnimatedSprite2D
@onready var hitBox = $HitBox
@onready var softCollision = $SoftCollision
var knockback_direction 
var state = IDLE
var player # For detection
var playerNode #For Exp purposes

enum{
	IDLE,
	WANDER,
	CHASE
}


func _ready():
	hitBox.attackDmg = stats.attackDmg
	playerNode = get_parent().get_parent().get_parent().get_node("Player")

func _process(delta):
	velocity = velocity.move_toward(Vector2.ZERO, 200*delta)
	
	
	match state:
		IDLE:
			seek_player()
			
		CHASE:
			player = $EnemyDetectionZone.player
			if player != null:
				
				var direction = (player.global_position - global_position)
				#velocity = (player.global_position - global_position).normalized()*SPEED
				
				if abs(direction.x)>1 or abs(direction.y)>1:
					velocity = velocity.move_toward(direction.normalized()*100, 350*delta)	
				
			else:
				state = IDLE
				
			animatedSprite.flip_h = velocity.x > 0
			
		WANDER:
			pass
			
	
	
	
	if softCollision.is_colliding() :
		velocity += softCollision.get_push_vector() * delta * 400
		
				
	move_and_slide()
	
	
func seek_player():
	if $EnemyDetectionZone.detected_player() :
		state = CHASE
	

func _on_stats_zero_health():
	queue_free()
	var deathEffect = EnemyDeathEffect.instantiate()
	get_parent().add_child(deathEffect)
	var deathEffectPositionX = global_position.x
	var deathEffectPositionY = global_position.y - 20
	deathEffect.global_position = Vector2(deathEffectPositionX, deathEffectPositionY)
	playerNode.gain_exp(stats.exp_value)


func _on_hurt_box_area_entered(area):
	knockback_direction = area.knockback_direction
	velocity = knockback_direction * 150
	stats.currentHealth -= area.attackDmg
	print("Damage taken: ", area.attackDmg)
	
		
