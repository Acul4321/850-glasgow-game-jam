extends Node2D
class_name Microgame

signal microgame_completed(success: bool)

@export var instruction_input: Constants.INPUT_TYPE = Constants.INPUT_TYPE.KEYBOARD
@export var instruction_text: String = "Do it!"
@export var duration: float = 6.0
@export var timeout_counts_as_win: bool = false
@export var win_by_default: bool = false

var is_success: bool = false
var is_timer_running: bool = false

func _ready() -> void:
	is_success = win_by_default
	
	if process_mode == Node.PROCESS_MODE_DISABLED:
		var current = process_mode
		while process_mode == current:
			await get_tree().process_frame
			
	set_process(true)

	_on_game_start()
	is_timer_running = true
	
	var current_time: int = duration
	while current_time > -1:
		Global.timer_update.emit(current_time)
		await Global.wait(0.6)
		current_time -= 1
		
	Global.timer_update.emit(-1)
	_on_timer_timeout()

func _on_game_start() -> void:
	pass

func _on_timer_timeout() -> void:
	is_timer_running = false
	if timeout_counts_as_win:
		is_success = true
	
	if is_success:
		print("WIN")
	else:
		print("LOSE")
		
	emit_signal("microgame_completed", is_success)
