extends Sprite2D

@export var amplitude_deg: float = 15.0
@export var duration: float = 0.6          # swing one side
@export var max_speed: float = 200.0        # px/s at peak
@export var noise_freq: float = 0.2     # how often it changes direction
@export var x_range: float = 200        # max drift from start x

var _noise := FastNoiseLite.new()
var _t := 0.0
var _start_x := 0.0

func _ready() -> void:
	_start_x = position.x
	_noise.seed = randi()
	_noise.noise_type = FastNoiseLite.TYPE_PERLIN
	_noise.frequency = noise_freq

	var tw := create_tween().set_loops()
	tw.tween_property(self, "rotation_degrees",  amplitude_deg, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tw.tween_property(self, "rotation_degrees", -amplitude_deg, duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _process(delta: float) -> void:
	_t += delta
	# noise in [-1, 1], changes smoothly → "walks" left/right for a bit
	var vx := _noise.get_noise_1d(_t) * max_speed
	var new_x := position.x + vx * delta
	# keep within a band around the start x so it doesn’t wander off
	new_x = clamp(new_x, _start_x - x_range, _start_x + x_range)
	position.x = new_x
