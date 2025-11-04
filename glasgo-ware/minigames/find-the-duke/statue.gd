extends Sprite2D

signal statue_clicked

const SPEED: float = 40.0

var direction: Vector2 = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()

func _ready():
	pass

func _process(delta):
	var viewport_rect = get_viewport_rect()
	var new_position = position + direction * SPEED * delta
	var sprite_size = texture.get_size() * scale

	# Teleport horizontally
	if new_position.x + sprite_size.x < 0:
		new_position.x = viewport_rect.size.x
	elif new_position.x > viewport_rect.size.x:
		new_position.x = -sprite_size.x

	# Teleport vertically
	if new_position.y + sprite_size.y < 0:
		new_position.y = viewport_rect.size.y
	elif new_position.y > viewport_rect.size.y + 10:
		new_position.y = -sprite_size.y

	position = new_position

func _on_self_area_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		print("target clicked")
		statue_clicked.emit()
