class_name MouseChaser
extends Sprite2D

var _ta = 0.0
const _UPDATE_INTERVAL := 0.02
const _LERP_FACTOR := 0.5

func _ready() -> void:
	visibility_changed.connect(
		func()->void:
			set_physics_process(visible)
			_ta = 0.0
			if visible:
				global_position = get_global_mouse_position()
	)
func _physics_process(delta: float) -> void:
	_ta += delta
	if _ta < _UPDATE_INTERVAL: return
	_ta = 0.0
	
	var mouse_pos := get_global_mouse_position()
	global_position = lerp(global_position, mouse_pos, _LERP_FACTOR)
