extends CharacterBody2D

@export var Orb : PackedScene

#상태 Idle, Run, Attack, Dead
var condition = "Idle" #default
var findPlayer = false
var displacement = 0
var DropOrb = false

#이동 관련
var speed = 90.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true


@onready var AS = $ACivilSprite
@onready var emote = $Emote/EmoteAnimation

@onready var emoteTimer = $Emote/EmoteTimer
@onready var alertTimer = $AlertTimer

@onready var hurtBox = $HurtBox/CollisionShape2D

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
			velocity.x = speed * 3
		displacement += 1
		
		if displacement > 300 and not findPlayer:
			change_condition_to_Idle()
	
	if condition == "Attack":
		#print("Now attacking")
		#print("current AS : " + AS.animation)
		AS.animation = "Attack"
		hurtBox.disabled = true
		if AS.frame == 4 or AS.frame == 5:
			hurtBox.disabled = false
		velocity.x = 0
	
	if condition == "Dead":
		AS.animation = "Dead"
		emote.visible = false
		velocity.x = 0
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
	if condition != "Dead" and condition != "Attack":
		condition = "Run"

func change_condition_to_Idle():
	if condition != "Dead":
		condition = "Idle"
		displacement = 0

func find_Player():
	findPlayer = true
	emote.play("Find")
	emoteTimer.resetTimer()
	condition = "Run"

func cant_find_Player():
	findPlayer = false
	emote.play("Lost")
	emoteTimer.resetTimer()
	condition = "Idle"

func _on_animated_sprite_2d_animation_looped():
	#print("loop")
	if AS.animation == "Attack" and condition == "Attack":
		condition = "Run"
		#print("check")


func _on_hurt_box_body_entered(body):
	if body.name == "Player":
		print(name + " hit " + body.name)


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
