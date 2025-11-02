extends RigidBody2D

func _ready() -> void:
	position.x += randi_range(-100, 100)
