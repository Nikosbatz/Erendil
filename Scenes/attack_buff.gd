extends Node2D

signal duration_ended


func casted():
	$DurationTimer.start()
	




func _on_duration_timer_timeout():
	duration_ended.emit()
	print("ended")
	queue_free()
