class_name BackgroundSprite
extends Sprite2D

#@onready var turn_on_tv_button: Button = $TurnOnTVButton
@onready var game_show_title_label: Label = $GameShowTitleLabel

var fade_tween: Tween = null
const FADE_DURATION := 0.5

func _ready() -> void:
	pass
	
func fade_out_title():
	self_modulate.a = 1.0
	visible = true
	if fade_tween:
		fade_tween.kill()
		fade_tween = null
	fade_tween = create_tween()
	fade_tween.tween_property(
		self,
		"self_modulate:a",
		0.0,
		FADE_DURATION
	)
	await fade_tween.finished
	fade_tween.kill()
	fade_tween = null
	visible = false
	
func fade_in_title():
	self_modulate.a = 0.0
	visible = true
	
	if fade_tween:
		fade_tween.kill()
		fade_tween = null
	fade_tween = create_tween()
	fade_tween.tween_property(
		self,
		"self_modulate:a",
		1.0,
		FADE_DURATION
	)
	await fade_tween.finished
	fade_tween.kill()
	fade_tween = null
