extends Node2D

@onready var regular_button: Button = $Regular
@onready var endless_button: Button = $Endless

func _ready():
	regular_button.pressed.connect(_regular_play_button)
	endless_button.pressed.connect(_endless_play_button)
	print(regular_button, endless_button)

func _regular_play_button():
	Global.game_type = Constants.GAME_TYPE.REGULAR
	Transition.fade_to_scene("res://scenes/elevator/elevator.tscn")

func _endless_play_button():
	Global.game_type = Constants.GAME_TYPE.ENDLESS
	Transition.fade_to_scene("res://scenes/elevator/elevator.tscn")
