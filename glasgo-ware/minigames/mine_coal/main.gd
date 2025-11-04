extends Microgame

@onready var pickaxe: AnimatedSprite2D = $Pickaxe
@onready var coal: TextureRect = $Coal
@onready var required_hits := 10

var pixel_size = 64

func _on_game_start() -> void:
	print(pickaxe.hits)
	pass
#
func _process(_delta):
	if is_timer_running:
		coal.material.set_shader_parameter("pixel_size", pixel_size / (pickaxe.hits + 1))
		
		if pickaxe.hits >= required_hits and !is_success:
				has_already_played_voice = true
				SoundManager.play_cheers()
				is_success = true
				coal.texture = null
				
		
