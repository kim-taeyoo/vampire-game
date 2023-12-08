extends Node

@onready var player = $"../Player"

#테스트용
const startMessage: Array[String] = [
	"Hi, friend.",
	"This is test message.",
	"Wait.."
]

func _unhandled_input(event):
	if event.is_action_pressed("Interact"):
		DialogManager.start_dialog(player.global_position, startMessage)
	
