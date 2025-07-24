class_name GameCamera
extends Camera2D
  
@export var zoom_pos: Vector2
@export var zoom_value := 1.0

var zoom_tween: Tween = null

const DEFAULT_ZOOM := 1.0
const DEFAULT_POS := Vector2.ZERO
const TWEEN_DURATION := 0.5
signal zoom_in_complete
signal zoom_out_complete


func _ready() -> void:
	position = DEFAULT_POS
	zoom = Vector2(DEFAULT_ZOOM,DEFAULT_ZOOM)

func zoom_in():
	if zoom_tween: return
	zoom_tween = create_tween().set_parallel()
	zoom_tween.tween_property(
		self,
		"zoom",
		Vector2(zoom_value,zoom_value),
		TWEEN_DURATION
	)
	zoom_tween.tween_property(
		self,
		"position",
		zoom_pos,
		TWEEN_DURATION
	)
	#var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	#sm.tween_up_sine_tone(TWEEN_DURATION)
	zoom_tween.finished.connect(
		func()->void:
			zoom_tween.kill()
			zoom_tween = null
			zoom_in_complete.emit()
			#sm.play_buzz(sm.BUZZ_2)
	)
	
func zoom_out():
	if zoom_tween: return
	zoom_tween = create_tween().set_parallel()
	zoom_tween.tween_property(
		self,
		"zoom",
		Vector2(DEFAULT_ZOOM,DEFAULT_ZOOM),
		TWEEN_DURATION
	)
	zoom_tween.tween_property(
		self,
		"position",
		DEFAULT_POS,
		TWEEN_DURATION
	)
	zoom_tween.finished.connect(
		func()->void:
			zoom_tween.kill()
			zoom_tween = null
			zoom_out_complete.emit()
	)
	
