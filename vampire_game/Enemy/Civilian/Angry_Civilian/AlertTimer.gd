extends Timer

@onready var enemy = $".."
@onready var sensor = $"../Sensor/EnemyDetectSensor"


func resetTimer():
	wait_time = 15.0
	start()
	sensor.enabled = false
	#print("enemy find player")

func _on_timeout():
	if enemy.condition != "Dead":
		enemy.cant_find_Player()
		await get_tree().create_timer(5.0).timeout
		sensor.enabled = true
		#print("enemy alert off")
