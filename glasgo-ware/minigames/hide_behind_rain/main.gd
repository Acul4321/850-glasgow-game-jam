extends Microgame

@onready var Umbrella := $Umbrella

func _on_game_start() -> void:
	pass

func _unhandled_input(event):
	if not is_timer_running:
		return
		
func _on_raindrop_hit(drop: Node2D) -> void:
	is_success = false

func _process(_delta):
	if not is_timer_running:
		return
		
	Umbrella.position = Vector2(get_global_mouse_position().x, Umbrella.position.y)
