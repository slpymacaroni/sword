extends CharacterBody2D

@onready var animatedsprite2d = $AnimatedSprite2D

func _physics_process(delta: float) -> void:
	var direction: = Input.get_vector("left" , "right" , "jump" , "down")
	if direction != Vector2.ZERO:
		velocity = direction * 48.0
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		animatedsprite2d.play("up")
	if Input.is_action_just_pressed("down"):
		animatedsprite2d.play("down")
	if Input.is_action_just_pressed("right"):
		animatedsprite2d.play("right")
	if Input.is_action_just_pressed("left"):
		animatedsprite2d.play("left")
