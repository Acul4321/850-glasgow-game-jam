extends Microgame

const CONE_NAMES := {
	IceCone = 0,
	TrafficCone = 1,
	PineCone = 2,
}

var selected_cone: AnimatedSprite2D = null
var drag_offset := Vector2.ZERO
var _can_select_cones: bool = true

@onready var head: AnimatedSprite2D = $Head

func _on_game_start() -> void:
	var cone_spots = [0, 1, 2]
	cone_spots.shuffle()
	
	for key in CONE_NAMES:
		var value: int = CONE_NAMES[key]
		var cone: AnimatedSprite2D = get_node(NodePath(key))
		cone.reparent(get_node("ConeSpots").get_node(str(cone_spots[value])))
		cone.position = Vector2.ZERO
		print(key, " -> ", value)
		
		var area2D: Area2D = cone.get_node("Area2D")
		area2D.input_event.connect(func(viewport: Node, event: InputEvent, shape_idx: int):
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed and _can_select_cones:
						cone.scale = Vector2.ONE * 1.5
						selected_cone = cone
						drag_offset = cone.global_position - get_global_mouse_position()
					else:
						if selected_cone == cone:
							cone.scale = Vector2.ONE
							selected_cone = null
							
							for area in area2D.get_overlapping_areas():
								if area.get_parent() == head:
									head.animation = cone.animation
									_can_select_cones = false
									cone.queue_free()
									head.material.set_shader_parameter("enabled", false)
									
									if cone.name == "TrafficCone":
										$HorseSmile.play("smile")
										is_success = true
									else:
										$HorseSmile.play("sad")
										is_success = false
		)

func _process(_delta):
	if is_timer_running:
		if selected_cone:
			selected_cone.global_position = get_global_mouse_position() + drag_offset
	else:
		_can_select_cones = false
