extends Area2D

var isPlayerIn = false
var cooldown = true

func _process(delta):
	if isPlayerIn:
		if cooldown:
			print("sunshine damage")
			cooldown = false
			await get_tree().create_timer(2.0).timeout
			cooldown = true

func _on_body_entered(body):
	if body.name == "Player":
		print(body.name + " in " + name)
		isPlayerIn = true


func _on_body_exited(body):
	if body.name == "Player":
		print(body.name + " out " + name)
		isPlayerIn = false
