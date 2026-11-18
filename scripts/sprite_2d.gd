extends Sprite2D

func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2d, "modulate", Color.RED, 1.0)
	tween.tween_property($Sprite2d, "scale", Vector2(), 1.0)
