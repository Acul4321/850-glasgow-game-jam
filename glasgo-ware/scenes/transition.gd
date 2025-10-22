extends CanvasLayer

@onready var anim_player = $AnimationPlayer

func fade_to_scene(path: String):
	anim_player.play("fade_out")
	await anim_player.animation_finished
	await Global.wait(.15)
	
	get_tree().change_scene_to_file(path)
	await get_tree().scene_changed
	
	get_tree().paused = true
	
	anim_player.play("fade_in")
	await anim_player.animation_finished
	await Global.wait(.15)
	
	get_tree().paused = false
