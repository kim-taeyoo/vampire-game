extends CharacterBody2D

#상태 Idle, Run, Stop, Dead
var condition = "Idle" #default
var findPlayer = false
var displacement = 0

#이동 관련
var speed = 50.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true


@onready var AS = $CowardSprite
@onready var emote = $Emote/EmoteAnimation

@onready var emoteTimer = $Emote/EmoteTimer
@onready var alertTimer = $AlertTimer

func _physics_process(delta):
	
	# 중력추가
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if condition == "Idle":
		AS.animation = "Idle"
		velocity.x = 0
		change_condition_to_Run()
		
	if condition == "Run":
		AS.animation = "Run"
		velocity.x = speed
		if findPlayer:
			velocity.x = speed * 6
		displacement += 1
		
		if displacement > 350 and not findPlayer:
			change_condition_to_Idle()
	
	if condition == "Stop":
		AS.animation = "Stop"
		velocity.x = 0
	
	if condition == "Dead":
		AS.animation = "Dead"
		emote.visible = false
		velocity.x = 0
		await get_tree().create_timer(5.0).timeout
		queue_free()
	
	move_and_slide()

func flip():
	facing_right = !facing_right
	
	scale.x = abs(scale.x) * -1
	emote.scale.x = emote.scale.x * -1
	
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
	

func change_condition_to_Run():
	await get_tree().create_timer(1.5).timeout
	if condition != "Dead" and condition != "Stop":
		condition = "Run"

func change_condition_to_Idle():
	if condition != "Dead":
		condition = "Idle"
		displacement = 0

func find_Player():
	findPlayer = true
	emote.play("Find")
	emoteTimer.resetTimer()
	flip()
	condition = "Run"

func cant_find_Player():
	findPlayer = false
	emote.play("Lost")
	emoteTimer.resetTimer()
	flip()
	condition = "Idle"

func _on_hit_box_area_entered(area):
	if area.get_parent().name == "Player" and area.name == "HurtBox":
		print("hit by" + area.get_parent().name + area.name)
		condition = "Dead"
