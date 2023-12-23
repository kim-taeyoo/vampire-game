#KeunWoongjae
extends Node2D

@export var startGame: PackedScene
@export var OptionMenu: PackedScene
@export var Credits: PackedScene

@onready var clickSound = $ButtonClick

func _on_start_pressed():
	get_tree().change_scene_to_packed(startGame)

func _on_option_pressed():
	var M = OptionMenu.instantiate()
	$CanvasLayer.add_child(M)
	clickSound.play(0)

func _on_credit_pressed():
	var M = Credits.instantiate()
	$CanvasLayer.add_child(M)
	clickSound.play(0)
