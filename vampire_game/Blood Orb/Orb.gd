extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()
	
func _on_body_entered(body):
	if body.name == "Player":
		print("Player get Orb")
	queue_free()

