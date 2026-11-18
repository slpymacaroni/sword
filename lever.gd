extends Node2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var door = $"../MovingDoor"
@export var open = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite_2d.play("closed")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword"):
		animated_sprite_2d.play("open")
		if open == false:
			open = true
			door._open()
