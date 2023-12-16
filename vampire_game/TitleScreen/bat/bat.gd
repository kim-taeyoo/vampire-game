extends Node2D

@onready var AS = $AnimatedSprite2D

var rng = RandomNumberGenerator.new()
var n = 0

var count = 0
func _ready():
	n = rng.randf_range(5.0, 10.0)
	#print(n)

func _on_animated_sprite_2d_animation_finished():
	AS.animation = "idle"
	AS.play()
	count = 0
	n = rng.randf_range(5.0, 10.0)
	#print("back to idel")


func _on_animated_sprite_2d_animation_looped():
	count += 1
	if count > n:
		AS.animation = "wing"
		#print("wing")
