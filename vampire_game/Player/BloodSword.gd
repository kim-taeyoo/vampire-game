#Kimtaeyu
extends Node2D

@onready var swordTimer = $SwordTimer

func startBloodSword(duration):
	swordTimer.wait_time = duration
	swordTimer.start()
	
func isBloodSword():
	return !swordTimer.is_stopped()
