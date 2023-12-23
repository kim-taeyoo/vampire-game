#Kimtaeyu
extends Node2D

@onready var dashTimer = $DashTimer

func startDash(duration):
	dashTimer.wait_time = duration
	dashTimer.start()
	
func isDashing():
	return !dashTimer.is_stopped()
