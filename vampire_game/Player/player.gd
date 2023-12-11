extends CharacterBody2D

var speed = 200
var gravity = 1000
var jump = -450
#상태 변수
var health = 3
var point = 0

#상호작용 애니메이션 직후 처리
var whatAnimation = "None"

#대쉬 관련
const dashSpeed = 550
const dashDuration = 0.6
@onready var dash = $Dash
var saveDirection = 1

#bloodSword
const bloodSwordMove = 30
const bloodSwordDuration = 1.05
@onready var bloodSword = $BloodSword

#bloodDagg
const bloodDaggMove = 30
const bloodDaggDuration = 1.1
@onready var bloodDagg = $BloodDagg

#Wall Jump
@onready var wallCheck = $WallCheck
var posibleWallJump = false

#애니메이션
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
var isFall = false

#공격 관련
@onready var hurtBox = $HurtBox

#스토리관련
@onready var story = $"../Story"

func _physics_process(delta):
	#스토리 진행될때 움직임 멈춤
	if story.isStoryAnimation:
		ap.play("Idle")
		return
	#다이어로그 나올때 움직임 멈춤
	if DialogManager.is_dialog_active:
		ap.play("Idle")
		return
		
	if not is_on_floor() and not posibleWallJump and not dash.isDashing():
			velocity.y += gravity * delta
	if not dash.isDashing() and not bloodSword.isBloodSword() and not bloodDagg.isBloodDagg():
	#중력
		if not is_on_floor() and not wallCheck.is_colliding():
#			velocity.y += gravity * delta
			#fall animation
			if velocity.y > 0:
				ap.play("Fall")
				whatAnimation = "Fall"
				wallCheck.enabled = true
	#			isFall = true
			elif velocity.y <= 0:
				ap.play("Jump")
				whatAnimation = "Jump"
				wallCheck.enabled = true
	#	if is_on_floor() and isFall:
	#		print("wkrehd")
	#		print(isFall)
	#		ap.play("Land")
	#		if ap.animation_finished:
	#			isFall = false
	#			print(isFall)
		#점프
		if Input.is_action_pressed("Jump") and is_on_floor():
			velocity.y = jump
		#move
		var direction = Input.get_axis("Left", "Right")
		if direction:
			saveDirection = direction
			velocity.x = direction * speed
			if is_on_floor():
				ap.play("Run")
				whatAnimation = "Run"
				wallCheck.enabled = false
		else: 
			velocity.x = move_toward(velocity.x, 0, speed)
			if is_on_floor():
				ap.play("Idle")
				whatAnimation = "Idle"
				wallCheck.enabled = false
		
		#rotate
		if Input.is_action_pressed("Left"):
			sprite.scale.x = abs(sprite.scale.x) * -1
			wallCheck.scale.x = abs(wallCheck.scale.x) * -1
		if Input.is_action_pressed("Right"):
			sprite.scale.x = abs(sprite.scale.x)
			wallCheck.scale.x = abs(wallCheck.scale.x)
		
		#상호작용 이후 처리
		if whatAnimation == "Dash":
			whatAnimation = "None"
		elif whatAnimation == "BloodSword":
			whatAnimation = "None"
		elif whatAnimation == "BloodDagg":
			whatAnimation = "None"

		#상호작용 애니메이션	
		#dash
		if Input.is_action_just_pressed("Dash"):
			velocity.y = 0
			velocity.x = saveDirection * dashSpeed
			dash.startDash(dashDuration)
			whatAnimation = "Dash"
			if saveDirection == 1:
				ap.play("Dash")
			elif saveDirection == -1:
				ap.play("Dash_Left")
				
		#bloodSword
		if Input.is_action_just_pressed("BloodSword") and is_on_floor():
			velocity.y = 0
			velocity.x = 40 * saveDirection
			whatAnimation = "BloodSword"
			bloodSword.startBloodSword(bloodSwordDuration)
			hurtBox.scale.x = saveDirection
			ap.play("BloodSword")
			
		#bloodDagg
		if Input.is_action_just_pressed("BloodDagg"):
			velocity.y = 0
			velocity.x = 0
			whatAnimation = "BloodDagg"
			bloodSword.startBloodSword(bloodDaggDuration)
			hurtBox.scale.x = saveDirection
			ap.play("BloodDagg")
			
		#Wall Jump
		if wallCheck.is_colliding() and (whatAnimation == "Fall" or whatAnimation == "Jump") and not posibleWallJump:
			velocity.y = 100
			posibleWallJump = true
#			wallCheck.startHangWall(1)
			ap.play("WallJump")
			whatAnimation = "WallJump"
		elif not wallCheck.is_colliding():
			posibleWallJump = false
		if wallCheck.is_colliding() and Input.is_action_pressed("Jump") and posibleWallJump:
			velocity.y = jump
			posibleWallJump = false
			ap.play("Jump")
			whatAnimation = "WallJump"
		if wallCheck.is_colliding() and not is_on_floor() and velocity.y >= -1 and velocity.y <= 1:
			posibleWallJump = false
			whatAnimation = "Jump"
			
	move_and_slide()

func _on_area_2d_body_entered(body):
	pass # Replace with function body.
