extends Node

@onready var player = $"../Player"
@onready var speech_sound = preload("res://Gui/Text_box/speech.wav")
@onready var storyPlayer = $StoryPlayer
@onready var timer = $Timer

var storyNum = 0
var isStoryAnimation = false

#테스트용
const startMessage: Array[String] = [
	"Hi, friend.",
	"Wait.",
	"This is test message.",
	"Wait.."
]

#상호작용
func _unhandled_input(event):
	if event.is_action_pressed("advance_dialog") and isStoryAnimation:
		if storyNum == 0:
			storyNum += 1
			isStoryAnimation = false
			storyPlayer.play("Place1_explain")
			timer.start(2.5)
	if event.is_action_pressed("Interact"):	
		DialogManager.start_dialog(player.global_position, startMessage, speech_sound)
	
#장소1
func _on_place_1_body_entered(body):
	if body.name == "Player" and storyNum == 0:
		isStoryAnimation = true
		storyPlayer.play("Place1_explain")
		timer.start(2.0)


func _on_timer_timeout():
	storyPlayer.pause()
