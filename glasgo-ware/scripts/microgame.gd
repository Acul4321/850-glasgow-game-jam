extends Node2D
class_name Microgame

signal microgame_completed(success: bool)

@export var instruction_text: String = "Do it!"
@export var duration: float = 6.0
@export var timeout_counts_as_win: bool = false
@export var win_by_default: bool = false

const INSTRUCTION_SCENE := preload("res://scenes/instruction.tscn")

var is_success: bool = false
var is_timer_running: bool = false

func _ready() -> void:
	is_success = win_by_default
	set_process(false)

	var instruction := INSTRUCTION_SCENE.instantiate()
	add_child(instruction)
	await instruction.start(instruction_text)

	_on_game_start()
	set_process(true)
	is_timer_running = true
	
	var current_time: int = duration
	while current_time > 0:
		Global.timer_update.emit(current_time)
		await Global.wait(0.6)
		current_time -= 1
		
	Global.timer_update.emit(current_time)
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
