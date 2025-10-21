extends CanvasLayer

signal timeout

@onready var prompt := $Prompt

func start(text: String, duration: float = 1.5) -> void:
	prompt.text = text
	prompt.visible = true
	await get_tree().create_timer(duration).timeout
	prompt.visible = false
	emit_signal("timeout")
