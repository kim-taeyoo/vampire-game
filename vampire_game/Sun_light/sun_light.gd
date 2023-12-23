#Keun Woongjae
extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		print(body.name + " in " + name)
		body.isPlayerinSunLight = true


func _on_body_exited(body):
	if body.name == "Player":
		print(body.name + " out " + name)
		body.isPlayerinSunLight = false
