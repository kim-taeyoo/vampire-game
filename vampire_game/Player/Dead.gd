extends Node2D

@onready var deadTimer = $"../Dead/DeadTimer"

func startDead(duration):
	deadTimer.wait_time = duration
	deadTimer.start()
	
func isDead():
	return !deadTimer.is_stopped()
