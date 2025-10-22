extends Node

# ultra hacky with the sauce
const PATH := "user://settings.cfg"
const PAGE := preload("res://scenes/titlescreen/settingspage.tscn")

var data := {}
var defaults := {}

var _cfg := ConfigFile.new()

func _ready() -> void:
	_build_defaults()
	_load_cfg_into_data()

func _build_defaults() -> void:
	defaults.clear()
	var page := PAGE.instantiate()
	add_child(page)
	page.hide()
	for cat in page.get_children():
		for n in cat.get_children():
			if n is BaseButton and n.toggle_mode:
				_place(defaults, cat.name, n.name, n.button_pressed)
					
	page.queue_free()

func _load_cfg_into_data():
	data = {}
	if _cfg.load(PATH) == OK:
		for cat in _cfg.get_sections():
			data[cat] = {}
			for key in _cfg.get_section_keys(cat):
				data[cat][key] = _cfg.get_value(cat, key)
	
	for cat in defaults:
		# i wish this were lua
		if not data.has(cat):
			data[cat] = {}
		for key in defaults[cat]:
			if not data[cat].has(key):
				data[cat][key] = defaults[cat][key]
				
func save() -> void:
	for cat in data:
		for key in data[cat]:
			_cfg.set_value(cat, key, data[cat][key])
	_cfg.save(PATH)

func get_value(cat: String, key: String, def = null):
	if def == null:
		def = defaults.get(cat, {}).get(key, null)
	return data.get(cat, {}).get(key, def)
	
func set_value(cat: String, key: String, val):
	_place(data, cat, key, val)
	
func apply_to_page(root: Control) -> void:
	for cat in root.get_children():
		for n in cat.get_children():
			var v = get_value(cat.name, n.name)
			if n is BaseButton and n.toggle_mode:
				if v != null: n.button_pressed = bool(v)
	
func pull_from_page(root: Control) -> void:
	for cat in root.get_children():
		for n in cat.get_children():
			if n is BaseButton and n.toggle_mode:
				set_value(cat.name, n.name, n.button_pressed)
	
func _place(target: Dictionary, cat: String, key: String, val) -> void:
	if not target.has(cat):
		target[cat] = {}
	target[cat][key] = val
