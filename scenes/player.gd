extends CharacterBody2D
#this is a test for google drive sync
@export var SPEED: float = 140.0
@export var JUMP_VELOCITY: float = -300
@export var jumping = false
var can_dash: bool = true
var dash_cooldown_done: bool = true
@export var friction: float = 22.5
var direction2 := Input.get_axis("left", "right")
var dash_count = 0
var can_jump: bool = true
var dashing: bool = false
var running: bool = false
var direction
@export var health: int = 3
var KNOCKBACK_VELOCITY = 0.0



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var attacking = false
@onready var animation_player = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var hitimmunityplayer: AnimationPlayer = $hitimmunityplayer
@onready var debuglabel2 = $debuglabel2
@onready var collisionshape = $collisionshape
@onready var damagetint = $HUD/Control/Damagetint
@onready var levellabel = $HUD/Control/Levellabel
@onready var icetint = $HUD/Control/icetint
@onready var hurtsound = $hurtsound
@onready var whooshsound = $whooshsound
@onready var leveltimer = $leveltimer
@onready var freezetimer = $freezetimer
@onready var flipattackareasplayer = $flipattackareasplayer
@onready var animation_player4 = $AnimationPlayer4
@onready var dmgtintanimation = $HUD/Dmgtintanimation
@onready var combotimer = $combotimer
@onready var finishertimer = $finishertimer
@onready var animation_player5 = $AnimationPlayer5
@onready var comboing: bool = false
@onready var combostep1: bool = false
@onready var animation_player6 = $AnimationPlayer6
@onready var finishcombo: bool = false
@onready var combocooldowntimer = $combocooldowntimer
@onready var can_combo: bool = true
@onready var hitstoptimer = $hitstoptimer
@onready var ShakeAnimation = $ShakeAnimation
@onready var camera = $Camera2D
@onready var JumpAttackPlayer = $JumpAttackPlayer
@onready var walljumpraycastright = $WallJumpRaycastRight
@onready var walljumpraycastleft = $WallJumpRaycastLeft
@onready var coyotetimer = $coyotetimer
@onready var can_wall_jump: bool = true
@onready var wall_jumping: bool = false
@onready var wall_jump_velocity
@onready var hpbarfill = $HUD/Control/HPBarFill

func _ready() -> void:
	animation_player.play("RESET")
	flipattackareasplayer.play("RESET")
	animation_player5.play("RESET")
	dmgtintanimation.play("RESET")
	levellabel.position.y = 1
	levellabel.text = "Level 1"
	if get_tree().current_scene.name == "level1":
		levellabel.text = "Level 1"
		levellabel.position.x = 125
	if get_tree().current_scene.name == "level2":
		levellabel.text = "Level 2"
		levellabel.position.x = 125
	if get_tree().current_scene.name == "level3":
		levellabel.text = "Level 3"
		levellabel.position.x = 125



func _process(delta: float):
	move_and_slide()
	hpbarfill.size.y = health / 4.65
	if Input.is_action_pressed("sword") and attacking == false and is_on_floor():
		attack()
		if comboing == false:
			combotimer.start()
	elif Input.is_action_pressed("sword") and attacking == false and is_on_floor() == false:
		jumpattack()
	if Input.is_action_just_pressed("sword") and combotimer.time_left > 0 and combotimer.time_left != 0.3 and is_on_floor():
		combo()
	if Input.is_action_just_pressed("sword") and finishertimer.time_left > 0 and finishertimer.time_left != 0.4:
		finisher()
		attacking = false
		SPEED = 140
	if direction == 0 and Input.is_action_just_released("right") or Input.is_action_just_released("left"):
		running = false
	if health <= 0:
		Engine.time_scale = 0.5 
		collisionshape.disabled = true
		await get_tree().create_timer(1).timeout
		Engine.time_scale = 1
		get_tree().reload_current_scene()
	if direction == 1:
		flipattackareasplayer.play("swordareaflipright")
	elif direction == -1:
		flipattackareasplayer.play("swordareaflipleft")
	

func attack():
	attacking = true
	animation_player4.play("sword1")
	await animation_player4.animation_finished
	attacking = false

func jumpattack():
	attacking = true
	JumpAttackPlayer.play("Jumpattack")
	await JumpAttackPlayer.animation_finished
	attacking = false


func combo():
	if finishertimer.time_left == 0:
		finishertimer.start()
	comboing = true
	animation_player5.play("sword2")
	await animation_player5.animation_finished
	comboing = false

func finisher():
	finishcombo = true
	animation_player6.play("finisher")
	await animation_player6.animation_finished
	finishcombo = false
	

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("left"):
		sprite.scale.x = abs(sprite.scale.x) * -1
	if Input.is_action_just_pressed("right"):
		sprite.scale.x = abs(sprite.scale.x)
	if can_jump == false and is_on_floor():
		can_jump = true

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if jumping == false:
			pass
	else:
		dash_count = 0
	# Handle jump.
	if Input.is_action_just_pressed("jump") and can_jump == true:
		velocity.y = JUMP_VELOCITY
		jumping = true
		can_jump = false
		animated_sprite_2d.play("jump")
	if not is_on_floor() and coyotetimer.time_left == 0:
		coyotetimer.start()
	if Input.is_action_just_released("jump"):
		$jumptimer.start()
		pass
	if Input.is_action_just_released("jump"):
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 2500)
		await get_tree().create_timer(0.1).timeout
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980)
	if Input.is_action_just_pressed("jump"):
		PhysicsServer2D.area_set_param(get_viewport().find_world_2d().space, PhysicsServer2D.AREA_PARAM_GRAVITY, 980)

	# Handle wall jump.
	if not is_on_floor() and walljumpraycastleft.is_colliding() or walljumpraycastright.is_colliding():
		if Input.is_action_just_pressed("jump") and wall_jumping == false:
			velocity.y = JUMP_VELOCITY + -50
			wall_jumping = true
			animated_sprite_2d.play("walljump")
			await get_tree().create_timer(1).timeout
			wall_jumping = false

	# Go through semisolids
	if Input.is_action_just_pressed("down"):
		position.y += 2

	# Get the input direction: -1, 0, 1
	direction = Input.get_axis("left", "right")

	# Flips the sprite
	if direction > 0:
		animated_sprite_2d.flip_h = false
	elif direction < 0:
		animated_sprite_2d.flip_h = true

	# Play animations
	if Input.is_action_pressed("sword"):
		if is_on_floor() == false:
			animated_sprite_2d.play("sword_up")
		if comboing == false and is_on_floor():
			animated_sprite_2d.play("sword1")
		if comboing == true:
			animated_sprite_2d.play("sword2")
		if finishcombo == true:
			animated_sprite_2d.play("sword3")
	else:
		if direction == 0 and is_on_floor() and attacking == false and comboing == false and finishcombo == false:
			animated_sprite_2d.play("idle")
		elif is_on_floor() and dashing == false and attacking == false:
			if Input.is_action_pressed("left") or Input.is_action_pressed("right"):
					animated_sprite_2d.play("run")
		if Input.is_action_just_pressed("jump"):
			animated_sprite_2d.play("jump")
		if Input.is_action_just_pressed("dash") and can_dash == true and not direction == 0 :
			animated_sprite_2d.play("dash")

#TO DO: make it so that the player cannot combo while running


	# Apply movement
	if direction:
		velocity.x = direction * SPEED + KNOCKBACK_VELOCITY
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) 


	# Apply dash
	if Input.is_action_just_pressed("dash") and can_dash == true and dash_cooldown_done == true and dash_count < 1:
		SPEED = 450
		dashing = true
		await get_tree().create_timer(0.1).timeout
		SPEED = 140
		dash_count = 1
		can_dash = false
		dash_cooldown_done = false
		$dashcooldowntimer.start()
		await get_tree().create_timer(0.1).timeout
		dashing = false

func _on_jumptimer_timeout():
	jumping = false

func _on_dashcooldowntimer_timeout() -> void:
	dash_cooldown_done = true
	can_dash = true

func _on_coyotetimer_timeout() -> void:
	can_jump = false
	

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("healthpickup") and health != 100:
		health += 10
	if area.name == "crystal":
		levellabel.text = "Level Completed!"
		levellabel.position.x = 77
		await get_tree().create_timer(1).timeout
	if area.is_in_group("slime") and not area.is_in_group("ice"):
		dmgtintanimation.play("Dmgtint")
		ShakeAnimation.play("Shake1")
		camera._screenshake()
		hitstoptimer.start()
		Engine.time_scale = 0.01
		health += -10
		hurtsound.play()
		hitimmunityplayer.play("hit_immunity")
		if global_position.x < area.global_position.x: # if the slime is on the right
			SPEED = 140
			KNOCKBACK_VELOCITY = randf_range(-200.0 , -350.0)
			velocity.y = randf_range( -150.0, -200.0 )
			await get_tree().create_timer(0.1).timeout
			KNOCKBACK_VELOCITY = 0
		elif  global_position.x > area.global_position.x: # if the slime is on the left
			SPEED = 140
			KNOCKBACK_VELOCITY = randf_range(200.0 , 350.0)
			velocity.y = randf_range( -150.0, -200.0 )
			await get_tree().create_timer(0.1).timeout
			KNOCKBACK_VELOCITY = 0
	elif area.is_in_group("ice"):
		dmgtintanimation.play("Dmgtint")
		hurtsound.play()
		ShakeAnimation.play("Shake1")
		camera._screenshake()
		hitimmunityplayer.play("hit_immunity")
		velocity.y = randf_range( -150.0, -200.0 )
		health += -10
		if global_position.x < area.global_position.x: # if the slime is on the right
			SPEED = 140
			KNOCKBACK_VELOCITY = randf_range(-200.0 , -350.0)
			velocity.y = randf_range( -150.0, -200.0 )
			await get_tree().create_timer(0.1).timeout
			KNOCKBACK_VELOCITY = 0
		elif  global_position.x > area.global_position.x: # if the slime is on the left
			SPEED = 140
			KNOCKBACK_VELOCITY = randf_range(200.0 , 350.0)
			velocity.y = randf_range( -150.0, -200.0 )
			await get_tree().create_timer(0.1).timeout
			KNOCKBACK_VELOCITY = 0
		SPEED = 70
		icetint.energy = 0.5
		await get_tree().create_timer(2).timeout
		SPEED = 140
		icetint.energy = 0


func _on_leveltimer_timeout() -> void:
	levellabel.text = "Time's up!"
	levellabel.position.x = 110
	Engine.time_scale = 0.5 
	collisionshape.disabled = true
	await get_tree().create_timer(1).timeout
	Engine.time_scale = 1
	get_tree().reload_current_scene()


func _on_hitstoptimer_timeout() -> void:
	Engine.time_scale = 1
