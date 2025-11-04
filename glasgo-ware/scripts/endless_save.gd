extends Node

const SAVE_PATH := "user://endless.cfg"
@warning_ignore("shadowed_global_identifier")
func _save_endless_round(round) -> void:
	if Global.game_type != Constants.GAME_TYPE.REGULAR:
		var cfg := ConfigFile.new()
		cfg.load(SAVE_PATH)
		cfg.set_value("endless", "round", round)
		cfg.save(SAVE_PATH)

func _load_endless_round():
	var cfg := ConfigFile.new()
	var err := cfg.load(SAVE_PATH)
	if err == OK:
		return int(cfg.get_value("endless", "round", -1))
	else:
		return -1
