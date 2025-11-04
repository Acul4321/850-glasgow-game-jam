extends Microgame

@export var statueSprite: Array[CompressedTexture2D]
@onready var spawnNode: Node2D = $statues
@onready var statue := preload("res://minigames/find-the-duke/statue.tscn")
@onready var target: Sprite2D = $statues/target
@onready var amount := 40

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
		new_statue.scale = Vector2(0.05,0.05)
		new_statue.global_position = get_random_screen_pos()
		
		spawnNode.add_child(new_statue)
	
func _process(_delta):
	pass


func _on_target_statue_clicked() -> void:
	print("target clicked")
	is_success = true
