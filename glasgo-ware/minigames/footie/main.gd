extends Microgame

@onready var ball: RigidBody2D = $Ball

	
func _process(_delta):
	if is_timer_running:
		if ball.position.y >= get_viewport().size.y - 300:
			is_success = false
