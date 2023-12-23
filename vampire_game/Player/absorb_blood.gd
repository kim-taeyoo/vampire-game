#Kimtaeyu
extends Node

@onready var player = $".."
@onready var ani = $"."
# Called when the node enters the scene tree for the first time.
func _ready():
	ani.global_position = player.global_position
	ani.position.y -= 10
	
