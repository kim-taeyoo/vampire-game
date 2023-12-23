#Keun Woongjae
extends CanvasLayer

@onready var AP = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func change_scene_to_file(target: String) -> void:
	visible = true
	AP.play("dissolve")
	await AP.animation_finished
	get_tree().change_scene_to_file(target)
	AP.play_backwards("dissolve")
	await AP.animation_finished
	visible = false

func change_scene_to_packed(target: PackedScene) -> void:
	visible = true
	AP.play("dissolve")
	await AP.animation_finished
	get_tree().change_scene_to_packed(target)
	AP.play_backwards("dissolve")
	await AP.animation_finished
	visible = false
