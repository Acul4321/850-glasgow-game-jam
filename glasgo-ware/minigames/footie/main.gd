extends Microgame

@onready var ball: RigidBody2D = $Ball
@onready var bg: TextureRect = $BG

@onready var footballer: AnimatedSprite2D = $Footballer

@export var celtic_field: Color = Color(0.0, 1.0, 0.233, 1.0)
@export var celtic_cross: Color = Color(1.0, 1.0, 1.0, 1.0)

@export var is_celtic = randi() % 2 == 0

func _on_game_start() -> void:
	if is_celtic:
		print("celtic")
		bg.material.set_shader_parameter("color_field", celtic_field)
		bg.material.set_shader_parameter("color_cross", celtic_cross)
		footballer.play("celtic")


func _process(_delta):
	if is_timer_running:
		if ball.position.y >= 320:
			if !has_already_played_voice:
				has_already_played_voice = true
				SoundManager.play_jeers()
			is_success = false


func _on_ball_body_entered(body: Node) -> void:
	
	if body is CharacterBody2D:
		ball.apply_impulse(Vector2(randi_range(-50,50), -50))
