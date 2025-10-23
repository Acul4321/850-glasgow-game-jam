extends CanvasLayer

@onready var container: SubViewportContainer = $SubViewportContainer
@onready var vp_old: SubViewport = $SubViewportContainer/SubViewportOld
@onready var vp_new: SubViewport = $SubViewportContainer/SubViewportNew
@onready var transition_rect: ColorRect = $TransitionLayer
var mat: ShaderMaterial

func _ready():
	mat = transition_rect.material
	_resize_viewports()
	get_viewport().size_changed.connect(_resize_viewports)
	visible = false

func _resize_viewports():
	var sizei = get_viewport().get_visible_rect().size
	vp_old.size = sizei
	vp_new.size = sizei

func transition_to(packed: PackedScene, duration := 0.5, post_duration := 0.0, pause_on_transition := true, delete_old_scene := true) -> void:
	if get_tree().current_scene == null:
		push_warning("No current_scene found. Are you transitioning from boot?")
	
	visible = true

	var old_scene := get_tree().current_scene
	if old_scene:
		old_scene.get_parent().remove_child(old_scene)
		vp_old.add_child(old_scene)
	
	var new_scene := packed.instantiate()

	if pause_on_transition:
		var old_mode := old_scene and old_scene.process_mode
		var new_mode := new_scene.process_mode
		if old_scene:
			old_scene.process_mode = Node.PROCESS_MODE_DISABLED
		new_scene.process_mode = Node.PROCESS_MODE_DISABLED

	vp_new.add_child(new_scene)
	mat.set_shader_parameter("tex_prev", vp_old.get_texture())
	mat.set_shader_parameter("tex_next", vp_new.get_texture())
	mat.set_shader_parameter("radius", 0.0)
	mat.set_shader_parameter("center", Vector2(0.5, 0.5))

	var tw := create_tween()
	tw.tween_property(mat, "shader_parameter/radius", 1.2, duration)
	await tw.finished
	await Global.wait(post_duration)

	if pause_on_transition and new_scene:
		new_scene.process_mode = Node.PROCESS_MODE_INHERIT

	if old_scene and delete_old_scene:
		vp_old.remove_child(old_scene)
		old_scene.queue_free()
	
	new_scene.reparent(get_tree().root)
	get_tree().current_scene = new_scene

	visible = false
