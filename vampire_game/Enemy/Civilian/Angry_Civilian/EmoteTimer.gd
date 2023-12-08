extends Timer

@onready var emote = $"../EmoteAnimation"


func resetTimer():
	emote.visible = true
	wait_time = 3.0
	start()
	

func _on_timeout():
	emote.visible = false
	emote.pause()
	print("emote end")

	
