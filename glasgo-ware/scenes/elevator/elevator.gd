extends Control

const INSTRUCTION_SCENE := preload("res://scenes/elevator/instruction.tscn")
const INPUTTYPE_SCENE := preload("res://scenes/elevator/inputtype.tscn")

const INSTRUCTION_WAIT := 1.2
const SPEEDUP_WAIT := 2.5
const BOSS_WAIT := 3

@export var lives: int = 3
@export var rounds_per_speedup: int = 5

var round: int = 1

@onready var Door: AnimatedSprite2D = $Door
@onready var Status: Label = $Status
@onready var WinOrLose: Label = $WinOrLose
@onready var PitchEffect: AudioEffectPitchShift = AudioServer.get_bus_effect(AudioServer.get_bus_index("Pitch"), 0)

var minigame_ignorelist := []
var rng:= RandomNumberGenerator.new()
var last_index:= -1
func next_minigame(count: int) -> int:
	if count <= 1:
		return 0

	if minigame_ignorelist.is_empty():
		minigame_ignorelist = range(count)
		minigame_ignorelist.shuffle()

		if last_index != -1 and minigame_ignorelist[0] == last_index:
			var swap_i = rng.randi_range(1, minigame_ignorelist.size() - 1)
			var temp = minigame_ignorelist[0]
			minigame_ignorelist[0] = minigame_ignorelist[swap_i]
			minigame_ignorelist[swap_i] = temp

	var index = minigame_ignorelist.pop_back()

	if index == last_index and not minigame_ignorelist.is_empty():
		var new_index = minigame_ignorelist.pop_back()
		minigame_ignorelist.append(index)
		index = new_index

	last_index = index
	return index
	
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
	
	Engine.time_scale = 1
	AudioServer.playback_speed_scale = 1
	
	Global.game_started = true
			
	while true:
		Global.timer_update.emit(-1)
		Door.animation = "idle"
		Door.scale = Vector2(1, 1)
		Door.modulate.a = 1
		WinOrLose.visible = false
		
		Status.text = "Round: " + str(round) + "\nLives: " + "X".repeat(lives)
		Status.visible = true
		
		if Global.game_type == Constants.GAME_TYPE.REGULAR and round >= 15:
				Engine.time_scale = 1
				AudioServer.playback_speed_scale = 1
				
				SoundManager.play_song("MinigameBoss")
				var speedup := INSTRUCTION_SCENE.instantiate()
				speedup.is_boss = true
				add_child(speedup)
				speedup.start("BOSS TIME!", BOSS_WAIT)
				await Global.wait(BOSS_WAIT + 0.2)
		else:
			if round % rounds_per_speedup == 0:
				SoundManager.play_song("MinigameSpeedUp")
				var speedup := INSTRUCTION_SCENE.instantiate()
				speedup.is_speedup = true
				add_child(speedup)
				
				speedup.start("SPEED UP!", SPEEDUP_WAIT)
				await Global.wait(SPEEDUP_WAIT + 0.2)
				
				Engine.time_scale *= 1.25
				AudioServer.playback_speed_scale *= 1.25
		
		var minigame_idx := next_minigame(minigames.size())
		var minigame := minigames[minigame_idx].instantiate()
		
		var inputtype_node: Node2D = INPUTTYPE_SCENE.instantiate()
		inputtype_node.input_type = minigame.instruction_input
		inputtype_node.position = (get_viewport_rect().size / 2)
		add_child(inputtype_node)
		
		SoundManager.play_song("NextMinigame")
		await Global.wait(1)
		
		var instruction := INSTRUCTION_SCENE.instantiate()
		add_child(instruction)
		
		instruction.start(minigame.instruction_text, INSTRUCTION_WAIT)
		await Global.wait(INSTRUCTION_WAIT)
		Status.visible = false
		inputtype_node.queue_free()
		
		var tween_2 := create_tween()
		tween_2.tween_property(Door, "scale", Vector2(3, 3), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		
		var shader_name = "Door" #TransitionManager.SHADERS.keys().pick_random()
		TransitionManager.transition_to(minigame, 0.3, 0.0, false, false, self, shader_name)
		
		minigame.duration += 0.3
		minigame.process_mode = Node.PROCESS_MODE_INHERIT
		var parent = get_parent()
		parent.add_child(minigame)
		parent.move_child(self, -1)
		
		var result = await minigame.microgame_completed
		print("WINNING RESULT: ", result)
		Global.timer_update.emit(-1)
		minigame.process_mode = Node.PROCESS_MODE_DISABLED
		
		var tween_1 := create_tween()
		tween_1.tween_property(Door, "scale", Vector2(1, 1), 0.35).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
		tween_1.parallel().tween_callback(func(): Door.animation = "idle").set_delay(0.3)
		TransitionManager.transition_to(self, 0.3, 0.0, false, false, minigame, shader_name, true)
		
		if result:
			SoundManager.play_song("MinigameWin")
		else:
			SoundManager.play_song("MinigameLose")
		
		await Global.wait(0.35)
		
		var has_already_played_voice : bool = minigame.has_already_played_voice
		minigame.queue_free()
		
		if result:
			if !has_already_played_voice:
				SoundManager.play_voice("Cheers")
			WinOrLose.text = "ROUND WIN!"
			WinOrLose.label_settings.font_color = Color(0,1,0)
		else:
			if !has_already_played_voice:
				SoundManager.play_voice("Jeers")
			WinOrLose.text = "ROUND LOST!"
			WinOrLose.label_settings.font_color = Color(1,0,0)
			lives -= 1
		
		WinOrLose.visible = true
		Status.text = "Round: " + str(round) + "\nLives: " + ("X".repeat(lives))
		Status.visible = true
		
		await Global.wait(1.5)
		
		if lives <= 0:
			Engine.time_scale = 1
			AudioServer.playback_speed_scale = 1
			SoundManager.play_voice("Jeers")
			SoundManager.play_song("GameOver")
			WinOrLose.text = "GAME OVER"
			WinOrLose.label_settings.font_color = Color(1,0,0)
			await Global.wait(4)
			TransitionManager.transition_to(load("res://scenes/titlescreen/titlescreen.tscn"), 0.4, 0.2, true, true, null, "Scotland")
			break
		elif round >= 15 and Global.game_type == Constants.GAME_TYPE.REGULAR:
			Engine.time_scale = 1
			AudioServer.playback_speed_scale = 1
			SoundManager.play_voice("Cheers")
			SoundManager.play_song("MinigameWin")
			WinOrLose.text = "YOU WIN!"
			WinOrLose.label_settings.font_color = Color(.7,1,.3)
			await Global.wait(4)
			TransitionManager.transition_to(load("res://scenes/titlescreen/titlescreen.tscn"), 0.4, 0.2, true, true, null, "Scotland")
			break
		
		round += 1
