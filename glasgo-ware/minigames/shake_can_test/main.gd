extends Microgame

@export var required_presses := 10
var press_count := 0
var shake_intensity := 0.0
@onready var can_sprite := $IrnBru

func _on_game_start() -> void:
	can_sprite.rotation = 0.0
	press_count = 0
	shake_intensity = 0.0

func _unhandled_input(event):
	if not is_timer_running:
		return

	if event.is_action_pressed("ui_accept"):
		press_count += 1
		increase_shake()

		if press_count >= required_presses:
			is_success = true
			explode_can()

func increase_shake():
	var progress := float(press_count) / required_presses
	shake_intensity = lerp(0.05, 0.4, progress)

func _process(_delta):
	if is_timer_running:
		# apply shake if game is running
		var offset := randf_range(-shake_intensity, shake_intensity)
		can_sprite.rotation = offset

func explode_can():
	can_sprite.hide()
	
	var boom_label := $BoomLabel
	boom_label.visible = true
	boom_label.position = get_viewport_rect().size / 2 - boom_label.size / 2
