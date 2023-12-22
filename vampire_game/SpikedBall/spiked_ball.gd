extends StaticBody2D

@export var Player : PackedScene
@onready var Box = $HurtBox
signal hit_Spiked(box)

func _on_hurt_box_body_entered(body):
	if body.name == "Player":
		emit_signal("hit_Spiked", Box)
