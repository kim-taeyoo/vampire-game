extends RayCast2D

@onready var CheckTime = $CheckTime

func starHangWall(duration):
	CheckTime.wait_time = duration
	CheckTime.start()
	
func isHangWall():
	return !CheckTime.is_stopped()
