extends CharacterBody2D

signal healthChanged

var speed = 200
var gravity = 1000
var jump = -450
#상태 변수
@export var maxHealth = 100
var currentHealth  = 20
var getBlood = 0
@onready var hitBox = $HitBox
@onready var Player = $"."
var isHit = false
var isPlayerinSunLight = false
var SunLightTimer = true
@onready var hitTimer = $HitBox/HitTimer
@onready var knockbackTimer = $HitBox/KnockbackTimer
@onready var damagePopup = $PopupLocation

#레벨? 관련
signal getBloodNum
#상호작용 애니메이션 직후 처리
var whatAnimation = "None"

#대쉬 관련
const dashSpeed = 550
const dashDuration = 0.6
@onready var dash = $Dash
@onready var dashCooldownTimer = $Dash/DashCooldown
var isDash = true
var saveDirection = 1

#bloodSword
const bloodSwordMove = 30
const bloodSwordDuration = 1.05
@onready var bloodSword = $BloodSword

#bloodDagg
const bloodDaggMove = 30
const bloodDaggDuration = 1
@onready var bloodDagg = $BloodDagg

#Wall Jump
@onready var wallCheck = $WallCheck
var posibleWallJump = false

#Dead
@onready var dead = $Dead

#애니메이션
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
var isFall = false

#공격 관련
@onready var hurtBox = $HurtBox

#스토리관련
@onready var story = $"../Story"

#SFX
@onready var walkSound = $Sound/Walk
@onready var hitSound = $Sound/Hit
@onready var jumpSound = $Sound/Jump
@onready var sword1Sound = $Sound/SwordAtk1
@onready var sword2Sound = $Sound/SwordAtk2
@onready var swordSoundTimer = $Sound/swordSoundTimer
@onready var daggSound = $Sound/DaggAtk
@onready var dashSound = $Sound/Dash
@onready var absorbSound = $Sound/absor
@onready var deadSound = $Sound/Dead

#피 흡수
var isAbsorbBlood = false
@onready var absorbBloodAni = $AbsorbBlood
#스테이지 별 초기설정
func _ready():
	if get_parent().get_name() == "CaveStage":
		getBlood = 0
		currentHealth  = 20
	else:
		getBlood = 20
		currentHealth  = 100
		
func _physics_process(delta):
	#피흡수
	if isAbsorbBlood:
		absorbBloodAni.play("default")
		if not absorbSound.playing:
			absorbSound.play()
		else:
			absorbSound.stop()
			absorbSound.play()
		getBlood += 1
		if currentHealth < 90:
			currentHealth += 10
			healthChanged.emit()
		else:
			currentHealth = 100
			healthChanged.emit()
		emit_signal("getBloodNum")
		isAbsorbBlood = false
	#스토리 진행될때 움직임 멈춤
	if story.isStoryAnimation:
		velocity.x = 0
		ap.play("Idle")
	#다이어로그 나올때 움직임 멈춤
	if DialogManager.is_dialog_active:
		ap.play("Idle")
		return
		
	if not is_on_floor() and not posibleWallJump and not dash.isDashing():
			velocity.y += gravity * delta
			if is_on_floor():
				velocity.x = 0
	if not story.isStoryAnimation and not dash.isDashing() and not bloodSword.isBloodSword() and not bloodDagg.isBloodDagg() and knockbackTimer.is_stopped() and not whatAnimation == "Dead":
	#설정
		if isAbsorbBlood:
			isAbsorbBlood = false
		if sword1Sound.playing:
			sword1Sound.stop()
		if sword2Sound.playing:
			sword2Sound.stop()
		if daggSound.playing:
			daggSound.stop()
		if dashSound.playing:
			dashSound.stop()
			
	#중력
		if not is_on_floor() and not wallCheck.is_colliding():
#			velocity.y += gravity * delta
			#fall animation
			if velocity.y > 0:
				if jumpSound.playing:
					jumpSound.stop()
				ap.play("Fall")
				whatAnimation = "Fall"
				wallCheck.enabled = true
	#			isFall = true
			elif velocity.y <= 0:
				ap.play("Jump")
				whatAnimation = "Jump"
				wallCheck.enabled = true
	#	if is_on_floor() and isFall:
	#		print("wkrehd")
	#		print(isFall)
	#		ap.play("Land")
	#		if ap.animation_finished:
	#			isFall = false
	#			print(isFall)
		#점프
		if Input.is_action_pressed("Jump") and is_on_floor():
			velocity.y = jump
			if not jumpSound.playing:
					jumpSound.play()
		#move
		var direction = Input.get_axis("Left", "Right")
		if direction:
			saveDirection = direction
			velocity.x = direction * speed
			if is_on_floor():
				ap.play("Run")
				whatAnimation = "Run"
				wallCheck.enabled = false
				if not walkSound.playing:
					walkSound.play()
		else: 
			velocity.x = move_toward(velocity.x, 0, speed)
			if is_on_floor():
				ap.play("Idle")
				whatAnimation = "Idle"
				wallCheck.enabled = false
		
		#rotate
		if Input.is_action_pressed("Left"):
			sprite.scale.x = abs(sprite.scale.x) * -1
			wallCheck.scale.x = abs(wallCheck.scale.x) * -1
			absorbBloodAni.scale.x = abs(absorbBloodAni.scale.x) * -1
		if Input.is_action_pressed("Right"):
			sprite.scale.x = abs(sprite.scale.x)
			wallCheck.scale.x = abs(wallCheck.scale.x)
			absorbBloodAni.scale.x = abs(absorbBloodAni.scale.x)
		
		#상호작용 이후 처리
		if whatAnimation == "Dash":
			whatAnimation = "None"
		elif whatAnimation == "BloodSword":
			whatAnimation = "None"
		elif whatAnimation == "BloodDagg":
			whatAnimation = "None"

		#상호작용 애니메이션	
		#dash
		if Input.is_action_just_pressed("Dash") and getBlood >= 5 and isDash:
			velocity.y = 0
			velocity.x = saveDirection * dashSpeed
			dash.startDash(dashDuration)
			whatAnimation = "Dash"
			if not dashSound.playing:
				dashSound.play()
			if saveDirection == 1:
				ap.play("Dash")
			elif saveDirection == -1:
				ap.play("Dash_Left")
			dashCooldownTimer.start()
			isDash = false
				
		#bloodSword
		if Input.is_action_just_pressed("BloodSword") and is_on_floor():
			velocity.y = 0
			velocity.x = 40 * saveDirection
			whatAnimation = "BloodSword"
			bloodSword.startBloodSword(bloodSwordDuration)
			hurtBox.scale.x = saveDirection
			ap.play("BloodSword")
			if not sword1Sound.playing:
				sword1Sound.play()
			swordSoundTimer.start()
			currentHealth -= 3
			healthChanged.emit()
			
		#bloodDagg
		if Input.is_action_just_pressed("BloodDagg") and getBlood >= 20:
			velocity.y = 0
			velocity.x = 0
			whatAnimation = "BloodDagg"
			bloodSword.startBloodSword(bloodDaggDuration)
			hurtBox.scale.x = saveDirection
			ap.play("BloodDagg")
			if not daggSound.playing:
				daggSound.play()
			currentHealth -= 3
			healthChanged.emit()
			
		#Wall Jump
		if getBlood >= 11:
			if wallCheck.is_colliding() and (whatAnimation == "Fall" or whatAnimation == "Jump") and not posibleWallJump:
				velocity.y = 100
				posibleWallJump = true
	#			wallCheck.startHangWall(1)
				ap.play("WallJump")
				whatAnimation = "WallJump"
			elif not wallCheck.is_colliding():
				posibleWallJump = false
			if wallCheck.is_colliding() and Input.is_action_pressed("Jump") and posibleWallJump:
				velocity.y = jump
				posibleWallJump = false
				ap.play("Jump")
				whatAnimation = "WallJump"
			if wallCheck.is_colliding() and not is_on_floor() and velocity.y >= -1 and velocity.y <= 1:
				posibleWallJump = false
				whatAnimation = "Jump"
			
		if isPlayerinSunLight:
			if SunLightTimer:
				get_damage_by_light()
				print("sunshine damaged Player")
				SunLightTimer = false
				await get_tree().create_timer(1.0).timeout
				SunLightTimer = true
		
		#player dead	
		if currentHealth <= 0:
			ap.stop()
			if sword1Sound.playing:
				sword1Sound.stop()
			if sword2Sound.playing:
				sword2Sound.stop()
			if walkSound.playing:
				walkSound.stop()
			if hitSound.playing:
				hitSound.stop()
			if jumpSound.playing:
				jumpSound.stop()
			if daggSound.playing:
				daggSound.stop()
			if absorbSound.playing:
				absorbSound.stop()
			if dashSound.playing:
				dashSound.stop()
			velocity.x = 0
			Player.set_collision_layer_value(1, false)
			Player.set_collision_layer_value(13, true)
			whatAnimation = "Dead"
			dead.startDead(1.5)
			if saveDirection == 1:
				ap.play("Dead")
			elif saveDirection == -1:
				ap.play("Dead_left")
			if not deadSound.playing:
				deadSound.play()
	move_and_slide()
	
func get_damage(body, dmageNum: int):
	if not isHit:
		currentHealth -= 5
		isHit = true
		ap.play("Hit")
		damagePopup.popup(dmageNum)
		hitTimer.start()
		healthChanged.emit()
		if not hitSound.playing:
			hitSound.play()
		
		#knockback
		knockbackTimer.start()
		if position.x - body.position.x > 0:
			velocity.x = 400
		else:
			velocity.x = -400
		
		print("hit by " + body.name)

func get_damage_by_light():
	currentHealth -= 50
	ap.play("Hit")
	damagePopup.popup(50)
	healthChanged.emit()

#func _on_hit_box_body_entered(body):
#	get_damage(body)
#

func _on_hit_box_area_entered(area):
	var areaParent
	if area.name == "Arrow":
		areaParent = area
	else:
		areaParent = area.get_parent()
	if area.name != "HitBox" and area.name != "SunLight":
		if area.name == "CivHurtBox":
			get_damage(areaParent, 5)
		elif area.name == "KnHurtBox":
			get_damage(areaParent, 15)
		elif area.name == "Arrow":
			get_damage(areaParent, 10)
		else:
			pass
func _on_timer_timeout():
	isHit = false
	if hitSound.playing:
		hitSound.stop()
	
func _on_knockback_timer_timeout():
	velocity.x = 0

func _on_spiked_ball_hit_spiked(area):
	var areaParent = area.get_parent()
	get_damage(areaParent, 5)

func _on_sword_sound_timer_timeout():
	if not sword2Sound.playing and not whatAnimation == "Dead":
			sword2Sound.play()
			
func _on_dash_cooldown_timeout():
	isDash = true
