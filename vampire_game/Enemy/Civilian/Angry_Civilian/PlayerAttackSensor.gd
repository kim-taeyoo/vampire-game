#KeunWoongjae
extends RayCast2D

@onready var enemy = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding() and enemy.condition != "Dead":
		enemy.condition = "Attack"
