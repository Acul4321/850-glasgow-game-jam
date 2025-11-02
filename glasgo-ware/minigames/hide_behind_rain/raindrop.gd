extends RigidBody2D

func _ready():
	linear_velocity = Vector2(0, 250)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "UmbrellaArea":
		queue_free()
	pass # Replace with function body.
