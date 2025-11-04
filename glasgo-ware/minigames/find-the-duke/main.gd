extends Microgame

@export var statueSprite: Array[CompressedTexture2D]
@onready var spawnNode: Node2D = $statues
@onready var statue := preload("res://minigames/find-the-duke/statue.tscn")
@onready var target: Sprite2D = $target
@onready var shader_material: ShaderMaterial = %spotlight.material
@onready var amount := 60

func get_random_screen_pos() -> Vector2:
	var viewport_size = get_viewport_rect().size
	return Vector2(
		randf_range(0, viewport_size.x),
		randf_range(0, viewport_size.y)
	)

func _on_game_start() -> void:
	target.global_position = get_random_screen_pos()
	
	for i in range(amount):
		var new_statue = statue.instantiate()
		new_statue.texture = statueSprite[randi_range(0,len(statueSprite)-1)]
		new_statue.scale = Vector2(0.25,0.25)
		new_statue.global_position = get_random_screen_pos()
		
		spawnNode.add_child(new_statue)
	
func _process(_delta):
	pass


func _on_target_statue_clicked() -> void:
	print("target clicked")
	is_success = true
	spawnNode.queue_free()
	target.set_script(null)
	
	# set spotlight
	var viewport_pos = target.get_global_position()
	var screen_size = get_viewport().get_visible_rect().size
	var uv_pos = Vector2(viewport_pos.x / screen_size.x, viewport_pos.y / screen_size.y)
	
	shader_material.set_shader_parameter("center", uv_pos)
	shader_material.set_shader_parameter("radius", 0.75)

	# Create a tween
	var t = create_tween()
	t.tween_property(shader_material, "shader_parameter/radius", 0.06, 0.2)
	t.play()
	%spotlight.visible = true
	SoundManager.play_cheers()
	has_already_played_voice = true
	
	if current_time > 3:
		current_time = 3
	
	
