extends Node

signal timer_update
var game_type: Constants.GAME_TYPE
var game_started := false

func wait(seconds: float, process_in_pause := false) -> void:
	await get_tree().create_timer(seconds, process_in_pause).timeout

func forever_wait_if_paused(node: Node) -> void:
	if node.process_mode == Node.PROCESS_MODE_DISABLED:
		var current = node.process_mode
		while node.process_mode == current:
			await get_tree().process_frame
