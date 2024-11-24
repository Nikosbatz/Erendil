extends Area2D
var cast_direction = Vector2.ZERO
var starting_global_pos
var knockback_direction = Vector2.ZERO
var attackDmg = 100

func _ready():
	starting_global_pos = global_position
	var tween = create_tween()
	tween.tween_property($AnimatedSprite2D, 'scale', Vector2(1.2,1.2), 0.3).from(Vector2(0,0))
	
func _process(delta):
	if cast_direction.x < 0:
		position.x += -1 * 250 * delta
	elif cast_direction.x > 0:
		position.x += 1 * 250 * delta
	elif cast_direction.y > 0:
		position.y += 1 * 250 * delta
	else:
		position.y += -1 * 250 * delta
		
	
func set_cast_direction(dir):
	cast_direction = dir
	knockback_direction = dir
	
	if cast_direction.x < 0:
		set_rotation_degrees(180)
	elif cast_direction.x > 0:
		pass
	elif cast_direction.y > 0:
		set_rotation_degrees(270)
	else:
		set_rotation_degrees(90)





func _on_area_entered(area):
	queue_free()
