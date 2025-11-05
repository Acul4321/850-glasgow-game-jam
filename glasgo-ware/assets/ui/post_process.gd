extends CanvasLayer

@onready var mat: ShaderMaterial = $FilterRect.material

func _ready() -> void:
	# Put this layer above gameplay and above popup windows.
	# CanvasLayer editor UI caps at 128, but popups render on layer 1024.
	# Setting 1025 in code forces this overlay to draw last. :contentReference[oaicite:2]{index=2}
	layer = 1025

func set_mode(m: int) -> void:
	mat.set_shader_parameter("mode", m)
