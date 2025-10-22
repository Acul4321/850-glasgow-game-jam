extends Node

# This signal called when the minigame finishes, emit_signal("minigame_end", true), etc
signal minigame_end(win)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(timer)
	timer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.handle_minigame_timer(timer)
	pass

func start()-> void:
	pass
	
func stops()-> void:
	pass
