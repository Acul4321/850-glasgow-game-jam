extends AnimatedSprite2D

@export var input_type: Constants.INPUT_TYPE = Constants.INPUT_TYPE.KEYBOARD

func _ready() -> void:
	animation = str(input_type)
	
	var old_scale = scale
	rotation_degrees = -100
	scale = Vector2.ZERO
	
	var tween := create_tween()
	tween.tween_property(self, "scale", old_scale, 0.2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "rotation_degrees", 0, 0.3).set_trans(Tween.TRANS_SPRING).set_ease(Tween.EASE_OUT)
	
