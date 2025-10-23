extends Control

const INSTRUCTION_SCENE := preload("res://scenes/elevator/instruction.tscn")
const INPUTTYPE_SCENE := preload("res://scenes/elevator/inputtype.tscn")

const INSTRUCTION_WAIT := 1.2

var round: int = 1
@export var lives: int = 3

@onready var Door: AnimatedSprite2D = $Door
@onready var Status: Label = $Status
@onready var WinOrLose: Label = $WinOrLose

func _ready() -> void:
	var minigames: Array[PackedScene] = []
	var dir := DirAccess.open("res://minigames")
	
	var hide = get_node_or_null("Hide")
	if hide:
		hide.visible = true
	
	for subdir_name in dir.get_directories():
		var path := "res://minigames/" + subdir_name + "/main.tscn"
		if ResourceLoader.exists(path):
			minigames.append(load(path))
			print("Loaded minigame:", path)
		
	await Global.forever_wait_if_paused(self)
	
	if hide:
		var tw := create_tween()
		tw.tween_property(hide, "modulate:a", 0, 0.2).set_trans(Tween.TRANS_CIRC)
		await tw.finished
		hide.queue_free()
	hide = null
	
	while true:
		Global.timer_update.emit(-1)
		Door.animation = "idle"
		Door.scale = Vector2(1, 1)
		Door.modulate.a = 1
		WinOrLose.visible = false
		
		Status.text = "Round: " + str(round) + "\nLives: " + "X".repeat(lives)
		Status.visible = true
		
		var minigame := minigames[randi() % minigames.size()].instantiate()
		
		var inputtype_node: Node2D = INPUTTYPE_SCENE.instantiate()
		inputtype_node.input_type = minigame.instruction_input
		inputtype_node.position = (get_viewport_rect().size / 2)
		add_child(inputtype_node)
		
		await Global.wait(1)
		
		var instruction := INSTRUCTION_SCENE.instantiate()
		add_child(instruction)
		
		instruction.start(minigame.instruction_text, INSTRUCTION_WAIT)
		await Global.wait(INSTRUCTION_WAIT)
		Status.visible = false
		inputtype_node.queue_free()
		
		var tween_1 := create_tween()
		tween_1.tween_property(Door, "scale", Vector2(2, 2), 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_1.parallel().tween_property(Door, "modulate:a", 0, 0.1)
		
		minigame.process_mode = Node.PROCESS_MODE_INHERIT
		var parent = get_parent()
		parent.add_child(minigame)
		parent.move_child(self, -1)
		
		var result = await minigame.microgame_completed
		print("result: ", result)
		minigame.process_mode = Node.PROCESS_MODE_DISABLED
		
		var tween_2 := create_tween()
		tween_2.tween_property(Door, "scale", Vector2(1, 1), 0.3).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		tween_2.parallel().tween_callback(func(): Door.animation = "idle").set_delay(0.3)
		tween_2.parallel().tween_property(Door, "modulate:a", 1, 0.2)
		
		await Global.wait(0.4)
		
		minigame.queue_free()
		
		if result:
			WinOrLose.text = "ROUND WIN!"
			WinOrLose.label_settings.font_color = Color(0,1,0)
		else:
			WinOrLose.text = "ROUND LOST!"
			WinOrLose.label_settings.font_color = Color(1,0,0)
			lives -= 1
		
		WinOrLose.visible = true
		Status.text = "Round: " + str(round) + "\nLives: " + ("X".repeat(lives))
		Status.visible = true
		
		await Global.wait(1.5)
		
		
		if lives <= 0:
			WinOrLose.text = "GAME OVER"
			WinOrLose.label_settings.font_color = Color(1,0,0)
			await Global.wait(2)
			TransitionManager.transition_to(load("res://scenes/titlescreen/titlescreen.tscn"))
			break
		
		round += 1
