extends CharacterBody2D

enum State {
	PATROL,
	PURSUE,
	IDLE,
	ATTACK,
}

var SPEED = randf_range(1200.0 , 1600.0)
var JUMP_VELOCITY = -200.0
var KNOCKBACK_VELOCITY = 0
@export var health: int = 3
@export var dead: bool = false
@export var minimum_patrol_time: float = 2.0
@export var maximum_patrol_time: float = 3.5

const HPDROP = preload("res://scenes/healthpickup.tscn")

var direction: float = 0.0
var state: State = State.PATROL
var patrol_timer: Timer
var do_loop: bool = true
var attack: bool = false
var jump_timer: Timer

@onready var detection_range: Area2D = $detectionrange
@onready var spotted_indicator: AnimationPlayer = $spottedindicator
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var ray_castright: RayCast2D = $RayCastright
@onready var ray_castdown: RayCast2D = $RayCastdown
@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var ray_castdownleft: RayCast2D = $RayCastdownleft
@onready var ray_castdownright: RayCast2D = $RayCastdownright
@onready var looptimer: Timer = $looptimer
@onready var player = $"../../player"
@onready var hurtsound = $hurtsound
@onready var hurt: bool = false
@onready var hurtparticles = $Hurtparticles
@onready var hitbox = $hitbox
@onready var dmgtextanimation = $DmgTextAnimation
@onready var dmglabel = $dmglabel
@onready var swordDmg = 20
@onready var marker2d = $Marker2D


func _ready() -> void: #randomly change directions during patrolling.
	detection_range.body_entered.connect(_on_player_detected)
	patrol_timer = Timer.new()
	add_child(patrol_timer)
	patrol_timer.one_shot = true
	patrol_timer.timeout.connect(_on_patrol_timer_timeout)
	patrol_timer.start(randf_range(minimum_patrol_time, maximum_patrol_time))
	spotted_indicator.play("RESET")
	jump_timer = Timer.new()
	add_child(jump_timer)
	jump_timer.timeout.connect(_on_jump_timer_timeout)
	jump_timer.start(randf_range(4.0 , 7.5))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if health <= 0:
		hurtsound.play()
		var x = randf_range(0,5)
		if x < 4 :
			var drop = HPDROP.instantiate()
			get_parent().add_child(drop)
			drop.position = marker2d.global_position
		queue_free()
	if not is_on_floor():
		velocity += get_gravity() * delta
	# Add movement based on state
	match state:
		State.PATROL:
			animated_sprite_2d.flip_h = direction < 0
			if hurt == false:
				animated_sprite_2d.play("walking")
			if ray_castright.is_colliding(): # wall detection code
				direction = -1
				animation_player.play("detectionrangeleft")
			if ray_castleft.is_colliding():
				direction = 1
				animation_player.play("detectionrangeright")
			if not ray_castdownleft.is_colliding(): #ledge detection code
				direction = 1
				animation_player.play("detectionrangeright")
			if not ray_castdownright.is_colliding():
				direction = -1
				animation_player.play("detectionrangeleft")
		State.PURSUE: #Currently the enemy will chase the player right off a cliff.
			face(player)
			if hurt == false:
				animated_sprite_2d.play("walking")
			direction = round(player.global_position - global_position).x
			if direction < 0:
				direction = -1
			elif direction  > 0:
				direction = 1
			if ray_castright.is_colliding() and is_on_floor(): 
				velocity.y = JUMP_VELOCITY
			if ray_castleft.is_colliding() and is_on_floor(): 
				velocity.y = JUMP_VELOCITY
		State.IDLE:
			direction = 0.0
			if hurt == false:
				animated_sprite_2d.play("idle")
	if direction:
		velocity.x =  delta * direction * SPEED + KNOCKBACK_VELOCITY
		_flip(direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	
	move_and_slide()

func face(node: Node2D) -> void:
	_flip(node.position.x - position.x)

func _flip(direction_float: float) -> void:
	animated_sprite_2d.flip_h = direction_float < 0
	if direction_float < 0:
		animation_player.play("detectionrangeleft")
	else:
		animation_player.play("detectionrangeright")

# You don't need to check the body name.
# Instead, put the Player on a separate physics layer,
# and have the Area2D only check that layer

func _on_player_detected(body: Node2D) -> void:
	player = body
	spotted_indicator.play("spotted")
	state = State.PURSUE
	patrol_timer.stop()

func _on_patrol_timer_timeout() -> void:
	state = [State.PATROL, State.PATROL, State.IDLE].pick_random() #Simple weighted choice
	if state == State.PATROL: #If patrolling, pick a random direction -> left (-1) or right (1)
		direction = [-1, 1].pick_random()
	patrol_timer.start(randf_range(minimum_patrol_time, maximum_patrol_time)) #Kick off the timer again
# Thanks to dragonforge-dev on the godot forum or on itch.io for providing (most of) the code mentioned above.

func _on_looptimer_timeout() -> void:
	do_loop = false
	print("test")

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword"):
		health = health - swordDmg
		hurt = true
		dmglabel.text = "-" + str(swordDmg)
		state = State.PURSUE
		hurtsound.play()
		animated_sprite_2d.play("hurt")
		dmgtextanimation.play("DmgTextAnimation")
		if global_position.x > player.global_position.x : # if the player is on the left
			KNOCKBACK_VELOCITY = randf_range(75.0 , 150.0)
			velocity.y = randf_range( -75, -100.0 )
			hurtparticles.play("ParticlesRight")
			await get_tree().create_timer(0.1).timeout
			KNOCKBACK_VELOCITY = 0
			await get_tree().create_timer(0.2).timeout
			hurt = false
		else: # if the player is on the right
			KNOCKBACK_VELOCITY = randf_range(-75.0 , -150.0)
			velocity.y = randf_range( -75, -100.0 )
			hurtparticles.play("ParticlesLeft")
			await get_tree().create_timer(0.1).timeout
			KNOCKBACK_VELOCITY = 0
			await get_tree().create_timer(0.2).timeout
			hurt = false

func _on_jump_timer_timeout() -> void:
	if is_on_floor():
		velocity.y = randf_range( -150.0, -200.0 )
