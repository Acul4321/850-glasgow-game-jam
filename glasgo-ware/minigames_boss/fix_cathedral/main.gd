extends Microgame

var selected_cone: Sprite2D = null
var drag_offset := Vector2.ZERO
var _can_select_cones: bool = true

var placed := 0
var cone_spots = [1, 2, 3, 4, 5, 6]

func _input(event: InputEvent) -> void:
	if not (event is InputEventMouseButton):
		return

func _on_game_start() -> void:
	show_timer = false
	cone_spots.shuffle()
	
	for value: int in cone_spots:
		var cone: Sprite2D = get_node("Cones").get_node(str(value))
		print(cone, cone.texture.get_size())
		cone.get_node("Area2D/CollisionShape2D").shape.size = cone.texture.get_size()
		cone.global_position = get_node("ConeSpots").get_node(str(cone_spots[value-1])).global_position
		
		var area2D: Area2D = cone.get_node("Area2D")
		area2D.input_event.connect(func(viewport: Node, event: InputEvent, shape_idx: int):
			if event is InputEventMouseButton:
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed and _can_select_cones:
						selected_cone = cone
						drag_offset = cone.global_position - get_global_mouse_position()
					else:
						if selected_cone == cone:
							selected_cone = null
							
							var p : Vector2 = get_node("CorrectSpots").get_node(str(value)).position
							if cone.position.distance_to(p) <= 10:
								cone.global_position = p
								area2D.queue_free()
								placed += 1
							#for area in area2D.get_overlapping_areas():
								#if area.get_parent() == head:
									#head.animation = cone.animation
									#_can_select_cones = false
									#cone.queue_free()
									#head.material.set_shader_parameter("enabled", false)
									#
									#has_already_played_voice = true
									#if cone.name == "TrafficCone":
										#SoundManager.play_cheers()
										#$HorseSmile.play("smile")
										#is_success = true
									#else:
										#SoundManager.play_jeers()
										#$HorseSmile.play("sad")
										#is_success = false
		)

func _process(_delta):
	if current_time < 0:
		$Timer.text = ""
	else:
		$Timer.text = "TIME LEFT: " + str(current_time)
	if is_timer_running:
		if placed == cone_spots.size():
			if !has_already_played_voice:
				if current_time > 3:
					current_time = 3
				has_already_played_voice = true
				SoundManager.stop_all()
				SoundManager.play_cheers()
				is_success = true
		
		if selected_cone:
			selected_cone.global_position = get_global_mouse_position() + drag_offset
	else:
		_can_select_cones = false
