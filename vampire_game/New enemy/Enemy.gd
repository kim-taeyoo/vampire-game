extends CharacterBody2D

#이동 관련
var speed = 60.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var facing_right = true

#좌우이동 알고리즘 관련
@onready var moveSensor = $MoveSensor


func _physics_process(delta):
	# 중력추가
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if not moveSensor.is_colliding() and is_on_floor():
		flip()

	velocity.x = speed
	move_and_slide()
	
func flip():
	facing_right =! facing_right
	
	scale.x = abs(scale.x) * -1
	if facing_right:
		speed = abs(speed)
	else:
		speed = abs(speed) * -1
