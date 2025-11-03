extends CanvasLayer

@onready var bomb_sprite: AnimatedSprite2D = $Bomb
@onready var paused_ui := $Paused
@onready var paused_text := $Paused/Label

var pause_debounce := false

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	_refresh()
	
	Global.timer_update.connect(_on_timer_updated)
	_on_timer_updated(-1) # reset timer ui
	
func _exit_tree() -> void:
	if get_tree().node_added.is_connected(_on_node_added):
		get_tree().node_added.disconnect(_on_node_added)
		
	if Global.timer_update.is_connected(_on_timer_updated):
		Global.timer_update.disconnect(_on_timer_updated)
	
func _on_node_added(node: Node) -> void:
	_refresh()
		
func _on_timer_updated(time_left: int):
	if time_left >= 0 and time_left <= 5:
		bomb_sprite.animation = str(time_left)
	else:
		bomb_sprite.animation = str(-1)
		
func _refresh() -> void:
	if get_tree().root.find_child("MainMenu", true, false):
		visible = false
	else:
		visible = true
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if !Global.game_started:
			return
		if pause_debounce:
			return
		pause_debounce = true
		_set_paused(not get_tree().paused)
		pause_debounce = false
		
func _set_paused(p: bool) -> void:
	if not p:
		for i in range(3,-1,-1):
			paused_text.text = "GO!" if i == 0 else str(i)
			await Global.wait(0.5, true)
	else:
		paused_text.text = "PAUSED"
	paused_ui.visible = p
	get_tree().paused = p
	
