extends Control

signal closed

@onready var back_button: Button = $Back
@onready var settings_buttons: Control = $Settings

func _ready() -> void:
	Settings.apply_to_page(settings_buttons)
	back_button.pressed.connect(func() -> void:
		Settings.pull_from_page(settings_buttons)
		Settings.save()
		PostProcess.mat.set_shader_parameter("mode", Settings.get_value("controls", "colour_blindness"))
		closed.emit()
		queue_free()
	)
	
	$Settings/controls/reset_endless_score.pressed.connect(func():
		var save_path := "user://endless.cfg"
		if FileAccess.file_exists(save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(save_path))
	)
