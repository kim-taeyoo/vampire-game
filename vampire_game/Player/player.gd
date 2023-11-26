extends CharacterBody2D

var speed = 200
var gravity = 1000
var jump = -450
#상태 변수
var health = 3
var point = 0
#대쉬 관련
const dashSpeed = 600
const dashDuration = 0.6
@onready var dash = $Dash
var saveDirection = 1

#애니메이션
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
var isFall = false

func _physics_process(delta):
	if not dash.isDashing():
	#중력
		if not is_on_floor():
			velocity.y += gravity * delta
			#fall animation
			if velocity.y > 0:
				ap.play("Fall")
	#			isFall = true
			elif velocity.y <= 0:
				ap.play("Jump")
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
		else: 
			velocity.x = move_toward(velocity.x, 0, speed)
			if is_on_floor():
				ap.play("Idle")
		
		#rotate
		if Input.is_action_pressed("Left"):
			sprite.scale.x = abs(sprite.scale.x) * -1
		if Input.is_action_pressed("Right"):
			sprite.scale.x = abs(sprite.scale.x)
			
		#dash
		if Input.is_action_just_pressed("Dash"):
			velocity.y = 0
			velocity.x = 0
			velocity.x = saveDirection * dashSpeed
			dash.startDash(dashDuration)
			if saveDirection == 1:
				ap.play("Dash")
			elif saveDirection == -1:
				ap.play("Dash_Left")
		
	move_and_slide()


func _on_area_2d_body_entered(body):
	pass # Replace with function body.
