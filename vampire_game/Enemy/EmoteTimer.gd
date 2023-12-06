extends Timer

@onready var enemy = $".."
@onready var emote = $"../EmoteAnimation"


func resetTimer():
	emote.visible = true
	#emote.animation.start()
	wait_time = 5.0
	start()
	

func _on_timeout():
	emote.visible = false
	#emote.animation.pause()
	print("emote end")

	
