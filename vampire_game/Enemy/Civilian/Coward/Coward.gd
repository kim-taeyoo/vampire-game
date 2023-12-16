extends CharacterBody2D

@export var Orb : PackedScene

#상태 Idle, Run, Stop, Dead
var condition = "Idle" #default
var findPlayer = false
var displacement = 0
var DropOrb = false

#이동 관련
var speed = 50.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true


@onready var AS = $CowardSprite
@onready var emote = $Emote/EmoteAnimation

@onready var emoteTimer = $Emote/EmoteTimer
@onready var alertTimer = $AlertTimer

@onready var Torch = $Torch

func _physics_process(delta):
	
	# 중력추가
	if not is_on_floor():
		velocity.y += gravity * delta
		
	match condition:
		"Idle":
			AS.animation = "Idle"
			velocity.x = 0
			
			Replace_torch(condition,AS.frame)
				
			change_condition_to_Run()
		
		"Run":
			AS.animation = "Run"
			velocity.x = speed
			if findPlayer:
				velocity.x = speed * 6
			displacement += 1
			
			Replace_torch(condition,AS.frame)
			
			if displacement > 300 and not findPlayer:
				change_condition_to_Idle()
		
		"Stop":
			AS.animation = "Stop"
			
			Replace_torch(condition,AS.frame)
			
			velocity.x = 0
		
		"Dead":
			AS.animation = "Dead"
			emote.visible = false
			velocity.x = 0
			
			Replace_torch(condition,AS.frame)
			
			if AS.frame == 4 and !DropOrb:
				makeOrb()
				DropOrb = true
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
		
func makeOrb():
	# instantiate a bullet if it has been assigned in the Inspector
	if !Orb:
		print("ERROR: Orb scene hasn't been assigned!")
		return
	
	var O = Orb.instantiate()

	$"../../Orb".add_child(O)
	O.transform = global_transform

func Replace_torch(state, frame):
	match state:
		"Idle":
			Torch.position = Vector2(7.5,-9)
			if frame == 3:
				Torch.position = Vector2(7.5,-8)
		
		"Run":
			Torch.position = Vector2(6.5,-9.5)
			match frame:
				1:
					Torch.position = Vector2(5.5,-11.5)
				2:
					Torch.position = Vector2(4.5,-10.5)
				3:
					Torch.position = Vector2(3.5,-10)
				4:
					Torch.position = Vector2(4.5,-7.5)
				5:
					Torch.position = Vector2(5,-8.5)
				6:
					Torch.position = Vector2(5.5,-9.5)
				7:
					Torch.position = Vector2(7,-11)
				8:
					Torch.position = Vector2(6.5,-9)
				9:
					Torch.position = Vector2(7.5,-9)
			
		"Stop":
			Torch.position = Vector2(1.5,-15.5)
			match frame:
				1:
					Torch.position = Vector2(0.5,-15.5)
				3:
					Torch.position = Vector2(0.5,-15.5)
					
		"Dead":
			Torch.position = Vector2(9,-8)
			if frame == 6:
				Torch.position = Vector2(9,-10.5)
				Torch.energy = 0.5
			if frame == 7:
				Torch.visible = false
