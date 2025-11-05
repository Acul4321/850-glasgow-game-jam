extends Control

var settings_scene: PackedScene = preload("res://scenes/titlescreen/settingspage.tscn")

@onready var buttons: VBoxContainer = $Buttons
@onready var regular_button: Button = $Buttons/Regular
@onready var endless_button: Button = $Buttons/Endless
@onready var settings_button: Button = $Buttons/Settings
@onready var PitchEffect: AudioEffectPitchShift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Pitch"), 0)

const ELEVATOR_SCENE := preload("res://scenes/elevator/elevator.tscn")

func _ready():
	var round = EndlessSave._load_endless_round()
	if round and round > 0:
		$Endless.text = "ENDLESS HIGH SCORE: " + str(round)
	
	Global.game_started = false
	AudioServer.playback_speed_scale = 1
	PostProcess.mat.set_shader_parameter("mode", Settings.get_value("controls", "colour_blindness"))
	PitchEffect.pitch_scale = 1
	regular_button.pressed.connect(_regular_play_button)
	endless_button.pressed.connect(_endless_play_button)
	settings_button.pressed.connect(_settings_spawn)

func _regular_play_button():
	_disable_buttons()
	SoundManager._play("CanOpen")
	Global.game_type = Constants.GAME_TYPE.REGULAR
	TransitionManager.transition_to(ELEVATOR_SCENE, 0.4, 0.2, true, true, null, "Scotland")

func _endless_play_button():
	_disable_buttons()
	SoundManager._play("CanOpen")
	Global.game_type = Constants.GAME_TYPE.ENDLESS
	TransitionManager.transition_to(ELEVATOR_SCENE, 0.4, 0.2, true, true, null, "Scotland")
	
func _settings_spawn():
	_disable_buttons()
	
	var active_settings_scene = settings_scene.instantiate()
	active_settings_scene.closed.connect(func(): _disable_buttons(false))
	add_child(active_settings_scene)

func _disable_buttons(disable: bool = true):
	var round = EndlessSave._load_endless_round()
	if round and round > 0:
		$Endless.text = "ENDLESS HIGH SCORE: " + str(round)
		
	for b in buttons.get_children():
		if b is Button:
			b.disabled = disable
