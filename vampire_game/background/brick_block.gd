extends RigidBody2D

var force = Vector2(0, 0)
@onready var Player = $"../../Player"
@onready var timer = $Timer
var xForce
var yForce
var detect = false
# Called when the node enters the scene tree for the first time.
func _ready():
	while not force:
		continue
	randomize()
	xForce = randi() % 401 + 300
	yForce = randi()  % 2
	if yForce == 0:
		yForce = randi() % 301 + 300  # 200부터 400 사이의 정수
	else:
		yForce = -1 * (randi() % 501 + 300)  # -200부터 -400 사이의 정수
		

	force = force * Vector2(xForce, 0) + Vector2(0, yForce)
	apply_central_impulse(force)
	timer.start()




func _on_timer_timeout():
	queue_free()
