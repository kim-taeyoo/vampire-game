extends Timer

@onready var enemy = $".."


func resetTimer():
	wait_time = 15.0
	start()
	#print("enemy find player")

func _on_timeout():
	if enemy.condition != "Dead":
		enemy.cant_find_Player()
		print("enemy alert off")