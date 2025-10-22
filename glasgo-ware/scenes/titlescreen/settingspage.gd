extends Control

signal closed

var settings_defaults := {}
var cfg := ConfigFile.new()

@onready var back_button: Button = $Back
@onready var settings: Control = $Settings

func _ready() -> void:
	_build_defaults()
	_load_settings()
	back_button.pressed.connect(func() -> void:
		_save_settings()
		closed.emit()
		queue_free()
	)

func _build_defaults() -> void:
	settings_defaults.clear()
	_each_button(func(cat, key):
		if key.toggle_mode:
			if not settings_defaults.has(cat.name):
				settings_defaults[cat.name] = {}
			settings_defaults[cat.name][key.name] = key.button_pressed
	)

func _each_button(cb: Callable) -> void:
	for cat in settings.get_children():
		for key in cat.get_children():
			if key is BaseButton and key.toggle_mode:
				cb.call(cat, key)

func _apply_from_cfg() -> void:
	_each_button(func(cat, key):
		var def = settings_defaults.get(cat.name, {}).get(key.name, key.button_pressed)
		key.button_pressed = bool(cfg.get_value(cat.name, key.name, def))
	)

func _save_settings() -> void:
	_each_button(func(cat, key):
		cfg.set_value(cat.name, key.name, key.button_pressed)
	)
	cfg.save("user://settings.cfg")

func _load_settings() -> void:
	if cfg.load("user://settings.cfg") == OK:
		_apply_from_cfg()

func restore_defaults() -> void:
	_each_button(func(cat, key):
		var def = settings_defaults.get(cat.name, {}).get(key.name, key.button_pressed)
		key.button_pressed = bool(def)
	)
