class_name MastermindLabel
extends Control

@onready var mastermind_label_holder: Node2D = %MastermindLabelHolder
@onready var mastermind_label: Label = %MastermindLabel

var tween: Tween = null

const TWEEN_DURATION := 0.75

func activate()->bool:
	
	mastermind_label.visible = false
	mastermind_label_holder.scale = Vector2(0.1, 0.1)
	mastermind_label.visible = true
	
	_clear_tween()
	
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm.tween_up_sine_tone(TWEEN_DURATION)
	tween.tween_property(
		mastermind_label_holder,
		"scale",
		Vector2(1.0, 1.0),
		TWEEN_DURATION
	)
	
	await tween.finished
	#TODO: play bell sound effect
	_clear_tween()
	
	
	
	return true
	
func _ready() -> void:
	mastermind_label.visible = false
	
func _clear_tween():
	if tween:
		tween.kill()
		tween = null
	
