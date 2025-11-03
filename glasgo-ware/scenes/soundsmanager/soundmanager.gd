extends Node

func play(sound_name: String):
	stop_all()
	(get_node(sound_name) as AudioStreamPlayer).play(0)

func stop_all():
	for child in get_children(true):
		if child is AudioStreamPlayer:
			child.stop()
