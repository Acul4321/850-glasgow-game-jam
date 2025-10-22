extends Node

signal timer_update
@export var game_type: Constants.GAME_TYPE

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func handle_minigame_timer(timer: Timer):
	if not timer.is_stopped():
		Global.timer_update.emit(ceil(timer.time_left))
	else:
		Global.timer_update.emit(0)
