extends Camera2D
var PANNING_SPEED = 25
var direction

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	if direction == -1:
		offset.x = move_toward(offset.x, -30, delta * PANNING_SPEED)
	if direction == 1:
		offset.x = move_toward(offset.x, +30, delta * PANNING_SPEED)


	
func _screenshake() -> void:
	offset.x = -4
	await get_tree().create_timer(0.1).timeout
	offset.x = 4
	await get_tree().create_timer(0.1).timeout
	offset.x = -3
	await get_tree().create_timer(0.1).timeout
	offset.x = 3
	await get_tree().create_timer(0.1).timeout
	offset.x = 1
	await get_tree().create_timer(0.1).timeout
	offset.x = 0
