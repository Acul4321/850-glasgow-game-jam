extends Sprite2D

signal statue_clicked

const SPEED: float = 50.0

# Current movement direction
var direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _ready():
	pass

func _process(delta):
	var viewport_rect = get_viewport_rect()
	var new_position = position + direction * SPEED * delta

	var sprite_size = texture.get_size() * scale

	# Left or right bounce
	if new_position.x < 0:
		new_position.x = 0
		direction.x *= -1
	elif new_position.x + sprite_size.x > viewport_rect.size.x:
		new_position.x = viewport_rect.size.x - sprite_size.x
		direction.x *= -1

	# Top or bottom bounce
	if new_position.y < 0:
		new_position.y = 0
		direction.y *= -1
	elif new_position.y + sprite_size.y > viewport_rect.size.y:
		new_position.y = viewport_rect.size.y - sprite_size.y
		direction.y *= -1

	position = new_position

func _on_self_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event is InputEventMouseButton):
		print("target clicked")
		statue_clicked.emit()
