extends CharacterBody2D

func _ready() -> void:
	velocity.y += -90

func _on_character_body_2d_area_entered(area: Area2D) -> void:
	if area.name == "playerhitbox":
		queue_free()

func  _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
