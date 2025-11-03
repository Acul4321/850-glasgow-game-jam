extends ReferenceRect

@onready var minigame: Microgame = get_parent()
@onready var collision_node: CollisionShape2D = get_node("StaticBody2D/CollisionShape2D")
@onready var collision_shape: RectangleShape2D = collision_node.shape
var RainDrop := preload("res://minigames/hide_behind_rain/raindrop.tscn")
var RNG := RandomNumberGenerator.new()

const TIME_PER_RAINDROP := 0.06
var time_delta := -1.0

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	time_delta += delta
	if time_delta >= TIME_PER_RAINDROP:
		time_delta = 0
		
		var extents = collision_shape.extents
		
		var raindrop: Node2D = RainDrop.instantiate()
		raindrop.global_position = collision_node.global_position + Vector2(
			RNG.randf_range(-extents.x, extents.x),
			RNG.randf_range(-extents.y, extents.y),
		)
		
		raindrop.rain_hit.connect(minigame._on_raindrop_hit)
		
		minigame.get_node("Raindrops").add_child(raindrop)
		
