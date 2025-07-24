class_name GeneralKnowledge
extends Control
@onready var panel: Panel = $Panel
@onready var red_x: Sprite2D = $Panel/Sprite2D
@onready var gk_label: Label = %GKLabel
@onready var tcm_label: Label = %TCMLabel
@onready var gk_label_holder: Node2D = %GKLabelHolder
@onready var tcm_label_holer: Node2D = %TCMLabelHoler

var tween: Tween = null

const TWEEN_DURATION := 0.75

#@warning_ignore("unused_signal")
#signal sequence_finished

func _ready() -> void:
	gk_label.visible = true
	red_x.visible = false
	tcm_label.visible = false
	

func activate()->bool:
	gk_label.visible = false
	red_x.visible = false
	tcm_label.visible = false
	
	gk_label_holder.scale = Vector2(0.1, 0.1)
	gk_label.visible = true
	
	_clear_tween()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(
		gk_label_holder,
		"scale",
		Vector2(1.0, 1.0),
		TWEEN_DURATION
	)
	await tween.finished
	# TODO: play bell sound effect
	_clear_tween()
	return true
	
	

func show_red_X():
	gk_label.visible = true
	red_x.visible = true
	tcm_label.visible = false
	# TODO: play buzzer sound effect

func show_tcm()->bool:
	gk_label.visible = false
	red_x.visible = false
	tcm_label.visible = false
	
	tcm_label_holer.scale = Vector2(0.1, 0.1)
	tcm_label.visible = true
	
	_clear_tween()
	
	tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(
		tcm_label_holer,
		"scale",
		Vector2(1.0,1.0),
		TWEEN_DURATION
	)
	await tween.finished
	# TODO: play bell sound effect
	_clear_tween()
	
	return true
	
func _clear_tween():
	if tween:
		tween.kill()
		tween = null
	
