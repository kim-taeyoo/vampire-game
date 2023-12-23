#KeunWoongjae
extends RayCast2D

@onready var enemy = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (not is_colliding() or enemy.is_on_wall()) and enemy.is_on_floor() and enemy.condition != "Dead":
		if enemy.findPlayer:
			enemy.condition = "Stop"
		else:
			enemy.flip()
