extends Node2D

@export var startGame: PackedScene
@export var OptionMenu: PackedScene

func _on_start_pressed():
	get_tree().change_scene_to_packed(startGame)


func _on_option_pressed():
	var M = OptionMenu.instantiate()
	$CanvasLayer.add_child(M)
