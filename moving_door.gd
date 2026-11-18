extends Node2D
@onready var animated_sprite2d = $AnimatedSprite2D
@export var y_position: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _open():
	animated_sprite2d.play("moving")
	position.y += -32
	await get_tree().create_timer(0.05).timeout
	position.y += -16
	await get_tree().create_timer(0.05).timeout
	position.y += -8
	await get_tree().create_timer(0.1).timeout
	position.y += -4
	await get_tree().create_timer(0.1).timeout
	position.y += -2
	await get_tree().create_timer(0.1).timeout
	position.y += -1
	await get_tree().create_timer(0.1).timeout
	position.y += -1
