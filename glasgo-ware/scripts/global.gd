extends Node

signal timer_update
@export var game_type: Constants.GAME_TYPE

func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout

func forever_wait_if_paused(node: Node) -> void:
	if node.process_mode == Node.PROCESS_MODE_DISABLED:
		var current = node.process_mode
		while node.process_mode == current:
			await get_tree().process_frame
