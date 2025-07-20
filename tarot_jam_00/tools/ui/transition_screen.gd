class_name TransitionScreen
extends Control

@onready var black_rect: ColorRect = %BlackRect

var tween: Tween = null

signal fade_in_complete
signal fade_out_complete

const FADE_DURATION := 0.25

func fade_in():
	if tween:
		tween.kill()
		tween = null
	tween = create_tween()
	tween.tween_property(black_rect, "self_modulate:a", 1.0, FADE_DURATION)
	tween.finished.connect(
		func()->void:
			fade_in_complete.emit()
			tween.kill()
			tween = null
	)
	
func fade_out():
	if tween:
		tween.kill()
		tween = null
	tween = create_tween()
	tween.tween_property(black_rect, "self_modulate:a", 0.0, FADE_DURATION)
	tween.finished.connect(
		func()->void:
			fade_out_complete.emit()
			tween.kill()
			tween = null
	)
