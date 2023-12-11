extends Area2D

var speed = 400.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta


func _on_body_entered(body):
	if body.name == "Player":
		print("hit" + body.name)
	queue_free()
	
