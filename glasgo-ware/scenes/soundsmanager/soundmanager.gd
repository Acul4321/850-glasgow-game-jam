extends Node

@onready var rng := RandomNumberGenerator.new()
	
func play_song(sound_name: String):
	_play(sound_name)
	
func play_voice(sound_name: String):
	_play(sound_name, true, false)

func play_cheers():
	SoundManager._play("SuccessBell", false, false)
	_play("Cheers", true, false)

func play_jeers():
	_play("Jeers", true, false)
	
func _play(sound_name: String, any_type := false, stop_all_sounds := true):
	if stop_all_sounds:
		stop_all()
	
	var matches := []
	if any_type:
		for child in _get_descendants(self):
			if child is AudioStreamPlayer and child.name.begins_with(sound_name):
				matches.append(child)
	else:
		var p = find_child(sound_name, true, false)
		if p and p is AudioStreamPlayer:
			matches.append(p)
			
	if matches.size() > 0:
		var chosen = matches[rng.randi_range(0, matches.size() - 1)]
		chosen.play()

func _get_descendants(node: Node = null) -> Array:
	var result: Array = []
	for child in node.get_children():
		result.append(child)
		result += _get_descendants(child)
	return result

func stop_all():
	for child in ($Songs).get_children():
		if child is AudioStreamPlayer:
			child.stop()
