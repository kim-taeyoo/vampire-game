extends Control
@export var OptionMenu: PackedScene

@onready var clickSound = $ButtonClick

func _on_back_pressed():
	$"../..".get_tree().paused = false
	queue_free()

func _on_option_pressed():
	var M = OptionMenu.instantiate()
	$"..".add_child(M)
	clickSound.play(0)

func _on_exit_pressed():
	#print("pressed exit")
	$"../..".backToTitle()
	queue_free()
	
