extends Microgame

@onready var can_sprite := $Drink
var can_clones := []
var rng := RandomNumberGenerator.new()

@onready var bottle_ui := $BottleUI
@onready var bottle_ui_buttons := $BottleUI/Buttons

@onready var correct_buzzer := $Sounds/CorrectBuzzer
@onready var incorrect_buzzer := $Sounds/WrongBuzzer

const amount_of_clones := 10
const delay_step := 0.2
const tween_delay := 1.5
const total_drinks_wait_duration := (delay_step * amount_of_clones) + tween_delay

var most_drinks := {}
	
func _on_game_start() -> void:
	bottle_ui.visible = false
	for button: Button in bottle_ui_buttons.get_children():
		button.pressed.connect(func():
			if has_already_played_voice:
				return
			has_already_played_voice = true
			
			var is_the_most := true
			for i in range(2):
				if most_drinks[int(button.name)] < most_drinks[i]:
					is_the_most = false
					break
					
			is_success = is_the_most
			if is_success:
				correct_buzzer.play()
				SoundManager.play_cheers()
			else:
				incorrect_buzzer.play()
				SoundManager.play_jeers()
			bottle_ui.visible = false
		)
		
	var incremental_wait := 0.0
	
	for i in range(amount_of_clones):
		var idx := rng.randi_range(0, 2)
		var clone : AnimatedSprite2D= can_sprite.duplicate()
		clone.frame = idx
		var amnt: int = most_drinks.get_or_add(idx, 0)
		most_drinks[idx] = amnt + 1
		can_clones.append(clone)
		
		add_child(clone)
		call_deferred("move_can", incremental_wait, clone)
		incremental_wait += 0.2
	
	await Global.wait(total_drinks_wait_duration)
	
	bottle_ui.visible = true
	print("all tweens done")

func move_can(delay: float, can: Node2D):
	var tween := create_tween()
	tween.tween_property(can, "global_position", Vector2(680.0, can.position.y), 1.5) \
		.set_trans(Tween.TRANS_LINEAR) \
		.set_delay(delay)

func _process(_delta):
	if not is_timer_running:
		return
