#Kimtaeyu
extends Node2D

@onready var daggTimer = $DaggTimer

func startBloodDagg(duration):
	daggTimer.wait_time = duration
	daggTimer.start()
	
func isBloodDagg():
	return !daggTimer.is_stopped()
