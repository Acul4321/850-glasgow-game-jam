extends CanvasLayer

const bomb_textures: Array[Texture2D] = [
	preload("res://assets/game/bomb/0.png"),
	preload("res://assets/game/bomb/1.png"),
	preload("res://assets/game/bomb/2.png"),
	preload("res://assets/game/bomb/3.png"),
	preload("res://assets/game/bomb/4.png"),
	preload("res://assets/game/bomb/5.png"),
]

@onready var bomb_sprite: TextureRect = $Bomb

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
	if time_left >= 0 and time_left < bomb_textures.size():
		if bomb_textures[time_left]:
			bomb_sprite.texture = bomb_textures[time_left]
	else:
		bomb_sprite.texture = null
		
func _refresh() -> void:
	if get_tree().root.find_child("MainMenu", false, false):
		visible = false
	else:
		visible = true
	
