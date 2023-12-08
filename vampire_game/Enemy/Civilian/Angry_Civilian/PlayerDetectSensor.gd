extends RayCast2D

@onready var enemy = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_colliding() and enemy.condition != "Dead":
		if !enemy.findPlayer:
			enemy.find_Player()
		enemy.alertTimer.resetTimer()
