extends Node2D

@export var startGame: PackedScene

func _on_start_pressed():
	get_tree().change_scene_to_packed(startGame)
