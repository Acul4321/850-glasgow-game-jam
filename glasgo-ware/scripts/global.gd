extends Node

signal timer_update
@export var game_type: Constants.GAME_TYPE

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
