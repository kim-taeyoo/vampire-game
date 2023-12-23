#Make Scene and node Configuration: KimTaeyu
#Code below: KeunWoongjae
extends Node2D

signal gameclear
var claer = false

@export var pauseMenu: PackedScene

func _ready():
	DialogManager.DialogueEnd.connect(gameClear)

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
	
func _on_enemy_child_exiting_tree(node):
	#print("check")
	#print(str($Enemy.get_child_count()))
	if $Enemy.get_child_count() == 1:
		emit_signal("gameclear")
		claer = true
		print("no more enemy")
		
func gameClear():
	if claer:
		EndingScene.show_game_clear()
