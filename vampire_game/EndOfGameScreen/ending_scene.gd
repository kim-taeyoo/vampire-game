#Keun Woongjae
extends CanvasLayer

@onready var AP = $AnimationPlayer

func show_game_clear():
	visible = true
	AP.play("GameClear")
	await AP.animation_finished
	$Button.disabled = false
	
func show_game_over():
	visible = true
	AP.play("GameOver")
	await AP.animation_finished
	$Button.disabled = false

func _on_button_pressed():
	SceneTransition.change_scene_to_file("res://TitleScreen/title.tscn")
	visible = false
	AP.play("RESET")
	$Button.disabled = true
