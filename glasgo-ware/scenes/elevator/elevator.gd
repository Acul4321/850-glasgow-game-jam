extends Control

const TEST_MINIGAME := preload("res://minigames/shakeCan/main.tscn")
const INSTRUCTION_SCENE := preload("res://scenes/instruction.tscn")

const DOOR_IMAGES := {
	"Closed": preload("res://assets/game/bomb/doorclosed.png"),
	"Open": preload("res://assets/game/bomb/dooropened.png"),
}

const INSTRUCTION_WAIT := 1.3

var round: int = 1
@export var lives: int = 3

@onready var Door: TextureRect = $Door
@onready var Status: Label = $Status

func _ready() -> void:
	while true:
		Global.timer_update.emit(-1)
		Door.texture = DOOR_IMAGES["Closed"]
		Door.scale = Vector2(1, 1)
		$WinOrLose.visible = false
		
		Status.text = "Round: " + str(round) + "\nLives: " + "X".repeat(lives)
		Status.visible = true
		
		var minigame := TEST_MINIGAME.instantiate()
		var instruction := INSTRUCTION_SCENE.instantiate()
		add_child(instruction)
		
		instruction.start(minigame.instruction_text, INSTRUCTION_WAIT)
		await Global.wait(INSTRUCTION_WAIT)
		Door.texture = DOOR_IMAGES["Open"]
		Status.visible = false
		
		var tween_1 := create_tween()
		tween_1.tween_property(Door, "scale", Vector2(2, 2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

		minigame.process_mode = Node.PROCESS_MODE_INHERIT
		var parent = get_parent()
		parent.add_child(minigame)
		parent.move_child(self, -1)
		
		var result = await minigame.microgame_completed
		print("result: ", result)
		minigame.process_mode = Node.PROCESS_MODE_DISABLED
		
		var tween_2 := create_tween()
		tween_2.tween_property(Door, "scale", Vector2(1, 1), 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_2.parallel().tween_callback(func(): Door.texture = DOOR_IMAGES["Closed"]).set_delay(0.3)
		
		await Global.wait(0.3)
		
		if result:
			$WinOrLose.text = "ROUND WIN!"
			$WinOrLose.label_settings.font_color = Color(0,1,0)
		else:
			$WinOrLose.text = "ROUND LOST!"
			$WinOrLose.label_settings.font_color = Color(1,0,0)
			lives -= 1
		
		$WinOrLose.visible = true
		Status.text = "Round: " + str(round) + "\nLives: " + ("X".repeat(lives))
		Status.visible = true
		
		await Global.wait(0.7)
		
		minigame.queue_free()
		
		if lives <= 0:
			$WinOrLose.text = "GAME OVER"
			$WinOrLose.label_settings.font_color = Color(1,0,0)
			await Global.wait(2)
			Transition.fade_to_scene("res://scenes/titlescreen/titlescreen.tscn")
			break
		
		round += 1
