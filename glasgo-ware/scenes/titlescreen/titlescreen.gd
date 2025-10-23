extends Control

var settings_scene: PackedScene = preload("res://scenes/titlescreen/settingspage.tscn")

@onready var buttons: VBoxContainer = $Buttons
@onready var regular_button: Button = $Buttons/Regular
@onready var endless_button: Button = $Buttons/Endless
@onready var settings_button: Button = $Buttons/Settings

func _ready():
	regular_button.pressed.connect(_regular_play_button)
	endless_button.pressed.connect(_endless_play_button)
	settings_button.pressed.connect(_settings_spawn)

func _regular_play_button():
	_disable_buttons()
	Global.game_type = Constants.GAME_TYPE.REGULAR
	TransitionManager.transition_to(load("res://scenes/elevator/elevator.tscn"), 0.4, 0.2, true, true, null, "Scotland")

func _endless_play_button():
	_disable_buttons()
	Global.game_type = Constants.GAME_TYPE.ENDLESS
	TransitionManager.transition_to(load("res://scenes/elevator/elevator.tscn"), 0.4, 0.2, true, true, null, "Scotland")
	
func _settings_spawn():
	_disable_buttons()
	
	var active_settings_scene = settings_scene.instantiate()
	active_settings_scene.closed.connect(func(): _disable_buttons(false))
	add_child(active_settings_scene)

func _disable_buttons(disable: bool = true):
	for b in buttons.get_children():
		if b is Button:
			b.disabled = disable
