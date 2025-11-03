extends RigidBody2D

const SPEED = 10

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("ui_left"):
		position.x -= SPEED
	if Input.is_action_pressed("ui_right"):
		position.x += SPEED
		
