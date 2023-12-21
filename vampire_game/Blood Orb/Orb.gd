extends Area2D
	
func _on_body_entered(body):
	if body.name == "Player":
		$CollisionShape2D.shape = null
		body.isAbsorbBlood = true
		print("Player get Orb")
	queue_free()

