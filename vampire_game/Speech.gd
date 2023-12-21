extends Node

@onready var player = $"../Player"
@onready var speech_sound = preload("res://Gui/Text_box/speech.wav")
@onready var storyPlayer = $StoryPlayer
@onready var timer = $Timer
@onready var ExLabel = $interactEx

var storyNum = 0
var isStoryAnimation = false
var isCameraMove = false

#테스트용
const startMessage: Array[String] = [
	"(Press E button)",
	"I'm the last surviving child vampire.",
	"I ran away to the humans and came deep into the cave..",
	"Vampires dreamed of coexistence with humans, but they all died of human betrayal.",
	"I want revenge."
]
const place1Ex: Array[String] = [
	"The sunlight is blocking the road.",
	"I'm weak now so I can't use my dash abilities to pass through that sunlight.",
	"There are people who look weak in front of me, so I need to suck blood.",
]
const place2Ex: Array[String] = [
	"I have to climb a cliff to move forward.",
	"But I'm still weak.",
	"There's a strong looking knight but I need more blood to move forward.",
]
func _ready():
	ExLabel.visible = false
#	DialogManager.start_dialog(player.global_position, startMessage, speech_sound)

#상호작용
func _unhandled_input(event):
	if event.is_action_pressed("Interact"):
		if isStoryAnimation and not isCameraMove:
			if storyNum == 1:
				isCameraMove = true
				storyPlayer.play("Place1_explain")
	
#장소1
func _on_place_1_body_entered(body):
	if body.name == "Player" and storyNum == 0:
		storyNum += 1
		isStoryAnimation = true
		isCameraMove = true
		ExLabel.visible = true
		storyPlayer.play("Place1_explain")
		timer.start(2.0)


func _on_timer_timeout():
	print("timer")
	isCameraMove = false
	storyPlayer.pause()

func _on_story_player_animation_finished(anim_name):
	print("end")
	isCameraMove = false
	isStoryAnimation = false
	
	#explain
	if storyNum == 1:
		DialogManager.start_dialog(player.global_position, place1Ex, speech_sound)


func _on_player_get_blood_num():
	if player.getBlood == 5:
		pass
