extends Area2D

var player = null

func detected_player():
	return player != null
		
	
func _on_body_entered(body):
	player = body
	print(body)

func _on_body_exited(body):
	player = null
