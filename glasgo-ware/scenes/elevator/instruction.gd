extends CanvasLayer

signal timeout

@onready var prompt := $Prompt

func start(text: String, duration: float) -> void:
	prompt.text = text
	
	prompt.modulate.a = 0.0
	prompt.scale = Vector2(7, 7)
	
	prompt.set_anchor(SIDE_LEFT, 0.5)
	prompt.set_anchor(SIDE_TOP, 0.5)
	prompt.set_pivot_offset(prompt.size / 2)

	var tween_in = create_tween()
	tween_in.tween_property(prompt, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_in.parallel().tween_property(prompt, "modulate:a", 1.0, 0.1).set_trans(Tween.TRANS_SINE)
	
	await get_tree().create_timer(duration).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(prompt, "modulate:a", 0.0, 0.1).set_trans(Tween.TRANS_SINE)
	await tween_out.finished
	queue_free()
