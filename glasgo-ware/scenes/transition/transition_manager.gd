extends CanvasLayer

const SHADERS := {
	Circular = preload("res://shaders/transition_circular.gdshader"),
	Diagonal = preload("res://shaders/transition_diagonal.gdshader"),
	Hole = preload("res://shaders/transition_hole.gdshader"),
	Door = preload("res://shaders/transition_door.gdshader"),
	Scotland = preload("res://shaders/transition_scotland.gdshader"),
}

var mat: ShaderMaterial

@onready var container: SubViewportContainer = $SubViewportContainer
@onready var vp_old: SubViewport = $SubViewportContainer/SubViewportOld
@onready var vp_new: SubViewport = $SubViewportContainer/SubViewportNew
@onready var transition_rect: ColorRect = $TransitionLayer

func _ready():
	mat = transition_rect.material
	_resize_viewports()
	get_viewport().size_changed.connect(_resize_viewports)
	visible = false

func _resize_viewports():
	var sizei = get_viewport().get_visible_rect().size
	vp_old.size = sizei
	vp_new.size = sizei

func transition_to(
	packedscene_or_node: Variant, 
	duration := 0.5, 
	post_duration := 0.0, 
	pause_on_transition := true, 
	delete_old_scene := true,
	old_scene: Variant = null,
	preferred_shader_name: Variant = null,
	inverse_transition_effect: bool = false
	) -> void:
		
	if get_tree().current_scene == null:
		push_warning("No current_scene found. Are you transitioning from boot?")
	
	visible = true
	
	var new_shader: Shader = SHADERS[preferred_shader_name if preferred_shader_name else SHADERS.keys().pick_random()]

	if transition_rect.material == null:
		transition_rect.material = ShaderMaterial.new()

	transition_rect.material = transition_rect.material.duplicate()
	transition_rect.material.resource_local_to_scene = true

	mat = transition_rect.material as ShaderMaterial
	mat.shader = new_shader
	
	if not old_scene:
		old_scene = get_tree().current_scene
		
	if old_scene:
		old_scene.get_parent().remove_child(old_scene)
		vp_old.add_child(old_scene)
	
	var new_scene: Variant = packedscene_or_node
	if packedscene_or_node is PackedScene:
		new_scene = packedscene_or_node.instantiate()

	if pause_on_transition:
		if old_scene:
			old_scene.process_mode = Node.PROCESS_MODE_DISABLED
		new_scene.process_mode = Node.PROCESS_MODE_DISABLED
	
	if new_scene.get_parent():
		new_scene.get_parent().remove_child(new_scene)
		
	vp_new.add_child(new_scene)
		
	mat.set_shader_parameter("tex_prev", vp_new.get_texture() if inverse_transition_effect else vp_old.get_texture())
	mat.set_shader_parameter("tex_next", vp_old.get_texture() if inverse_transition_effect else vp_new.get_texture())
	mat.set_shader_parameter("center", Vector2(0.5, 0.5))
	
	var tw := create_tween()
	if inverse_transition_effect:
		mat.set_shader_parameter("progress", 1.1)
		tw.tween_property(mat, "shader_parameter/progress", 0.0, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	else:
		mat.set_shader_parameter("progress", 0.0)
		tw.tween_property(mat, "shader_parameter/progress", 1.1, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	await tw.finished
	if post_duration > 0:
		await Global.wait(post_duration)

	if pause_on_transition and new_scene:
		new_scene.process_mode = Node.PROCESS_MODE_INHERIT

	if old_scene and delete_old_scene:
		vp_old.remove_child(old_scene)
		old_scene.queue_free()
	
	new_scene.reparent(get_tree().root)
	get_tree().current_scene = new_scene

	visible = false
