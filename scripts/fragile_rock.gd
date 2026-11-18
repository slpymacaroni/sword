extends CharacterBody2D
@onready var animatedsprite2d = $AnimatedSprite2D
@onready var shakeanimation = $shakeanimation
@onready var collision = $CollisionShape2D
@onready var particlesanimation = $particlesanimation
@onready var respawnanimation = $RespawnAnimation
@onready var breaking: bool = false

func _ready() -> void:
	animatedsprite2d.play("default")
	respawnanimation.play("RESET")
	shakeanimation.play("RESET")
	particlesanimation.play("RESET")
	collision.disabled = false
	animatedsprite2d.visible = true

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().name == "player" and breaking == false:
		breaking = true
		animatedsprite2d.play("breaking")
		shakeanimation.play("shake")
		await get_tree().create_timer(0.7).timeout
		particlesanimation.play("particles")
		await get_tree().create_timer(0.3).timeout
		collision.disabled = true
		animatedsprite2d.visible = false
		await get_tree().create_timer(5).timeout
		respawnanimation.play("respawn")
		await respawnanimation.animation_finished
		_ready()
