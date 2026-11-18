extends Area2D

@onready var game_manager: Node = $"Game manager"
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_body_entered(body: Node2D):
	animation_player.play("pickup")
