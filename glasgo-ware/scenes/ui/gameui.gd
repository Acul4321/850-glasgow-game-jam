extends CanvasLayer

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	_refresh()
	
func _exit_tree() -> void:
	if get_tree().node_added.is_connected(_on_node_added):
		get_tree().node_added.disconnect(_on_node_added)
	
func _on_node_added(node: Node) -> void:
	_refresh()
		
func _refresh() -> void:
	if get_tree().root.find_child("MainMenu", false, false):
		visible = false
	else:
		visible = true
