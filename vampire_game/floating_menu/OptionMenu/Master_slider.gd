extends HSlider

var index = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	index = AudioServer.get_bus_index("Master")
	value = db_to_linear(AudioServer.get_bus_volume_db(index))

func _on_value_changed(value):
	AudioServer.set_bus_volume_db(index,linear_to_db(value))
