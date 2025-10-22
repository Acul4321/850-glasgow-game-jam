extends Control

signal closed

@onready var back_button: Button = $Back
@onready var settings_buttons: Control = $Settings

func _ready() -> void:
	Settings.apply_to_page(settings_buttons)
	back_button.pressed.connect(func() -> void:
		Settings.pull_from_page(settings_buttons)
		Settings.save()
		closed.emit()
		queue_free()
	)
