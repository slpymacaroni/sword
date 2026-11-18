extends Area2D

@onready var timer: Timer = $Timer

func _on_body_entered(body: CharacterBody2D) -> void:
	if body.name == "player":
		print("You died!")
		Engine.time_scale = 0.5 
		body.get_node("collisionshape").queue_free()
		timer.start()
	if body.name == "slime":
		print("slime ded :(")
		body.get_node("hurtbox").queue_free()



func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
	Engine.time_scale = 1
