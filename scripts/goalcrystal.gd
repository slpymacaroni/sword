extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "playerhitbox":
			animated_sprite_2d.play("collect")
			await animated_sprite_2d.animation_finished
			animated_sprite_2d.play("collected_idle")
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://scenes/worldmap.tscn")
