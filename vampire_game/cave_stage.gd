#Make Scene and node Configuration: KimTaeyu
#Code below: KeunWoongjae
extends Node2D

@export var pauseMenu: PackedScene

func _input(event):
	if event.is_action_pressed("pause"):
		pause()
		
func pause():
	get_tree().paused = true
	var M = pauseMenu.instantiate()
	$FloatWindow.add_child(M)

func backToTitle():
	#print("call title")
	DialogManager._back_to_title()
	get_tree().paused = false
	SceneTransition.change_scene_to_file("res://TitleScreen/title.tscn")
