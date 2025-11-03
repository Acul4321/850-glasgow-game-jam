extends CanvasLayer

signal timeout

@export var is_speedup := false
@onready var prompt := $Prompt

func start(text: String, duration: float) -> void:
	prompt.text = text
	
	prompt.modulate.a = 0.0
	prompt.scale = Vector2(7, 7)
	prompt.set_anchor(SIDE_LEFT, 0.5)
	prompt.set_anchor(SIDE_TOP, 0.5)
	prompt.set_pivot_offset((prompt.size / 2) + Vector2(0, 10))

	var tween_in = create_tween()
	tween_in.tween_property(prompt, "scale", Vector2(1, 1), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_in.parallel().tween_property(prompt, "modulate:a", 1.0, 0.1).set_trans(Tween.TRANS_SINE)
	
	if is_speedup:
		call_deferred("_speedup_effect")
	
	await get_tree().create_timer(duration).timeout
	
	var tween_out = create_tween()
	tween_out.tween_property(prompt, "modulate:a", 0.0, 0.15).set_trans(Tween.TRANS_SINE)
	await tween_out.finished
	queue_free()
	
func _ready():
	if get_tree().current_scene == self:
		is_speedup = true
		start("TEST!", 4)
		
func _speedup_effect():
	var half_cycle := 0.2
	var min_cycle := 0.1
	var accel := 0.8

	while true:
		var t1 := create_tween()
		t1.tween_property(prompt, "modulate", Color(0.294, 0.554, 0.931, 1.0), 0)
		await Global.wait(half_cycle)

		var t2 := create_tween()
		t2.tween_property(prompt, "modulate", Color(1, 1, 1), 0)
		await Global.wait(half_cycle)
		
		half_cycle = max(half_cycle * accel, min_cycle)
