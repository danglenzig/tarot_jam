class_name MemoryLabel
extends Control

@onready var memory_label_holder: Node2D = %MemoryLabelHolder
@onready var memory_label: Label = %MemoryLabel

var tween: Tween = null

const TWEEN_DURATION := 0.75

func _ready() -> void:
	memory_label.visible = false

func activate()->bool:
	
	memory_label.visible = false
	memory_label_holder.scale = Vector2(0.1, 0.1)
	memory_label.visible = true
	
	_clear_tween()
	
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm.tween_up_sine_tone(TWEEN_DURATION)
	tween.tween_property(
		memory_label_holder,
		"scale",
		Vector2(1.0, 1.0),
		TWEEN_DURATION
	)
	
	await tween.finished
	#TODO: play bell sound effect
	_clear_tween()
	
	
	
	return true
	
func _clear_tween():
	if tween:
		tween.kill()
		tween = null
