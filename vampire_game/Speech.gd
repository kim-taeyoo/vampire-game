extends Node

@onready var player = $"../Player"
@onready var speech_sound = preload("res://Gui/Text_box/speech.wav")
@onready var storyPlayer = $StoryPlayer
@onready var timer = $Timer
@onready var ExLabel = $interactEx

@export var CastleStage: PackedScene

var storyNum = 0
var isStoryAnimation = false
var isCameraMove = false

#abilityMessage
const dashMessage: Array[String] = [
	"I've recovered my dash ability by absorbing blood.",
	"Press the Z button to use the dash."
]
const wallJumpMessage: Array[String] = [
	"I've recovered my wall Jump ability by absorbing blood.",
	"I can do wall Jump by hanging from the wall and pressing space."
]
const DaggMessage: Array[String] = [
	"I've recovered my ability to attack Dagg by absorbing enough blood.",
	"Now I've recovered all my abilities.",
	"Let's break the rock and go to the castle and get revenge on the humans.",
	"The dagg attack can be used in the air.",
	"Press the C button,then I'll consume HP and dagg attack."
]
#placeMessage
const startMessage: Array[String] = [
	"(Press E button for next dialogue)",
	"I'm the last surviving child vampire.",
	"I ran away from the humans and came deep into this cave..",
	"I don't have much HP left.",
	"Vampires dreamed coexisting with humans, but they all died by humans' betrayal.",
	"I want revenge.",
	"I need to move right now."
]
const place1Ex: Array[String] = [
	"The sunlight is blocking the road.",
	"I'm too weak now so I can't use my dash abilities to pass through that sunlight.",
	"There are people who look weak in front of me, so I need to drink their blood.",
	"Press the X button,then I'll consume HP and attack with the blood sword."
]
const place2Ex: Array[String] = [
	"I have to climb a cliff to move forward.",
	"But I'm still weak.",
	"There are some knights look strong, but I need to drink more blood to move forward."
]
const place3Ex: Array[String] = [
	"The road to go is blocked by a big stone.",
	"I lack the power to use the Dagg attack ability to attack in the air and break that rock.",
	"I see strong enemies such as Archer and Knight.",
	 "But I have to kill them and drink blood to be strong."
]
const castleEx: Array[String] = [
	"I finally infiltrated the castle.",
	"I'll kill all the human in the castle."
]
func _ready():
	ExLabel.visible = false
	if get_parent().get_name() == "CaveStage":
		DialogManager.start_dialog(player.global_position, startMessage, speech_sound)
		storyNum = 0
	else:
		DialogManager.start_dialog(player.global_position, castleEx, speech_sound)
		storyNum = 4	

#상호작용
func _unhandled_input(event):
	if event.is_action_pressed("Interact"):
		if isStoryAnimation and not isCameraMove:
			if storyNum == 1:
				isCameraMove = true
				storyPlayer.play("Place1_explain")
			elif storyNum == 2:
				isCameraMove = true
				storyPlayer.play("place2_explain")
			elif storyNum == 3:
				isCameraMove = true
				storyPlayer.play("place3_explain")
	
#장소1
func _on_place_1_body_entered(body):
	print(body.name)
	if body.name == "Player" and storyNum == 0:
		storyNum += 1
		isStoryAnimation = true
		isCameraMove = true
		ExLabel.visible = true
		storyPlayer.play("Place1_explain")
		timer.start(2.0)
	
func _on_place_2_body_entered(body):
	if body.name == "Player" and storyNum == 1:
		storyNum += 1
		isStoryAnimation = true
		isCameraMove = true
		ExLabel.visible = true
		storyPlayer.play("place2_explain")
		timer.start(2.0)
		

func _on_place_3_body_entered(body):
	if body.name == "Player" and storyNum == 2:
		storyNum += 1
		isStoryAnimation = true
		isCameraMove = true
		ExLabel.visible = true
		storyPlayer.play("place3_explain")
		timer.start(2.0)
		
func _on_place_4_body_entered(body):
	if body.name == "Player" and storyNum == 3:
#		storyNum += 1
#		isStoryAnimation = true
#		isCameraMove = true
#		ExLabel.visible = true
#		storyPlayer.play("place3_explain")
#		timer.start(2.0)
		get_tree().change_scene_to_packed(CastleStage)
		
	
func _on_timer_timeout():
	print("timer")
	isCameraMove = false
	storyPlayer.pause()

func _on_story_player_animation_finished(anim_name):
	print("end")
	isCameraMove = false
	isStoryAnimation = false
	ExLabel.visible = false
	
	#explain
	if storyNum == 1:
		DialogManager.start_dialog(player.global_position, place1Ex, speech_sound)
	elif storyNum == 2:
		DialogManager.start_dialog(player.global_position, place2Ex, speech_sound)
	elif storyNum == 3:
		DialogManager.start_dialog(player.global_position, place3Ex, speech_sound)


func _on_player_get_blood_num():
	if player.getBlood == 5:
		DialogManager.start_dialog(player.global_position, dashMessage, speech_sound)
	elif player.getBlood == 11:
		DialogManager.start_dialog(player.global_position, wallJumpMessage, speech_sound)
	elif player.getBlood == 20:
		DialogManager.start_dialog(player.global_position, DaggMessage, speech_sound)
