extends Area2D
	
func _on_body_entered(body):
	if body.name == "Player":
		body.isAbsorbBlood = true
		print("Player get Orb")
	queue_free()

