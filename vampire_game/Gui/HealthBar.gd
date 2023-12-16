extends TextureProgressBar

@onready var player = $"../../Player"

func _ready():
	value = player.currentHealth * 100 / player.maxHealth

func _on_player_health_changed():
	value = player.currentHealth * 100 / player.maxHealth
	
#func _ready():
#	player.healthChanged.connect(update)
#	update()
#
#func update():
#	value = player.currentHealth * 100 / player.maxHealth
