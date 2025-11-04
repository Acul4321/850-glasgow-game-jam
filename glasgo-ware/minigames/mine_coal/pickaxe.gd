extends AnimatedSprite2D

var hits = 0
var inside = true
@onready var audio_stream_player: AudioStreamPlayer = $"../AudioStreamPlayer"

var mine_sound = preload("res://minigames/mine_coal/synthetic_explosion_1.mp3")



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = get_viewport().get_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if(!$"../Coal".texture):
		inside = false
	if(event is InputEventMouseButton && $"../Coal".texture):
		audio_stream_player.stream = mine_sound
		audio_stream_player.play()
		hits += 1


func _pickaxe_hit(area: Area2D) -> void:
	audio_stream_player.stream = mine_sound
	if inside:
		audio_stream_player.play()
		hits += 1
	print(hits)
