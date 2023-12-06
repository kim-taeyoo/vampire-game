extends CharacterBody2D

#상태 Idle, Run, Attack, Death
var condition = "Idle" #default
var findPlayer = false
var displacement = 0

#이동 관련
var speed = 60.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true

#좌우이동 알고리즘 관련
@onready var moveSensor = $Sensor/MoveSensor
@onready var playerDetectSensor = $Sensor/PlayerDetectSensor
@onready var playerAttackSensor = $Sensor/PlayerAttackSensor

@onready var AS = $AnimatedSprite2D
@onready var emote = $Emote/EmoteAnimation

@onready var emoteTimer = $Emote/EmoteTimer
@onready var alertTimer = $AlertTimer

@onready var hurtBox = $HurtBox/CollisionShape2D

func _physics_process(delta):
	# 중력추가
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not moveSensor.is_colliding() and is_on_floor():
		flip()
		
	if playerDetectSensor.is_colliding():
		find_Player()
		alertTimer.resetTimer()
		emoteTimer.resetTimer()
		
	if playerAttackSensor.is_colliding():
		condition = "Attack"
		
	if condition == "Idle":
		AS.animation = "Idle"
		velocity.x = 0
		change_condition_to_Run()
		
	if condition == "Run":
		AS.animation = "Run"
		velocity.x = speed
		if findPlayer:
			velocity.x = speed * 3
		displacement += 1
		
		if displacement > 150 and not findPlayer:
			change_condition_to_Idle()
	
	if condition == "Attack":
		AS.animation = "Attack"
		hurtBox.disabled = true
		if AS.frame == 4:
			hurtBox.disabled = false
		velocity.x = 0
	
	move_and_slide()

func flip():
	facing_right =! facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1

func change_condition_to_Run():
	await get_tree().create_timer(3.0).timeout
	condition = "Run"

func change_condition_to_Idle():
	condition = "Idle"
	displacement = 0

func find_Player():
	findPlayer = true
	emote.animation = "Find"
	if condition != "Attack":
		condition = "Run"

func cant_find_Player():
	findPlayer = false
	emote.animation = "Lost"
	condition = "Idle"

func _on_animated_sprite_2d_animation_looped():
	#print("loop")
	if condition == "Attack":
		condition = "Run"


func _on_hurt_box_body_entered(body):
	print("hit")
