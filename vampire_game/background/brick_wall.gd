#Kimtaeyu
extends RigidBody2D

@export var brickBlock :PackedScene
@onready var Player = $"../../Player"
var detect = false
var force

@onready var SFX = $AudioStreamPlayer2D
@onready var timer = $Timer
@onready var ani = $AnimationPlayer

func _on_area_2d_area_entered(area):
		
	var areaParent = area.get_parent()
	if areaParent.name == "Player" and area.name == "HurtBox" and not detect:
		if Player.position.x > position.x:
			force = Vector2(-1, 0)
		else:
			force = Vector2(1, 0) 
		detect = true
		
		for i in range(8):
			if !brickBlock:
				print("ERROR: brickBlock scene hasn't been assigned!")
				return
			var new_object = brickBlock.instantiate()
			new_object.force = force
			new_object.transform = global_transform 
			if i == 0:
				pass
			elif i == 1:
				new_object.position.x += 16
			elif i == 2:
				new_object.position.y -= 16
			elif i == 3:
				new_object.position.y -= 16
				new_object.position.x += 16
			elif i == 4:
				new_object.position.y -= 32
			elif i == 5:
				new_object.position.y -= 32
				new_object.position.x += 16
			elif i == 6:
				new_object.position.y -= 48
			elif i == 7:
				new_object.position.y -= 48
				new_object.position.x += 16
			get_parent().add_child(new_object)

		self.visible = false
		ani.play("Brick")
		SFX.play()
		timer.start()
	
func _on_timer_timeout():
	queue_free()
