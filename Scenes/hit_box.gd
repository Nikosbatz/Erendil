extends Area2D

var attackDmg = 1



func _on_area_entered(area):
	set_deferred("monitoring", false)
	$Timer.start()
	

func _on_timer_timeout():
	monitoring = true
	
