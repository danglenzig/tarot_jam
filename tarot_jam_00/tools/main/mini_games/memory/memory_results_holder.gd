class_name MemoryResultsHolder
extends Node2D

@onready var result_cards: HBoxContainer = %ResultCards
@onready var card_a_result: Control = %CardAResult
@onready var card_b_result: Control = %CardBResult
@onready var check_label: Label = %CheckLabel
@onready var ex_label: Label = %ExLabel

func _ready() -> void:
	_clear_results_holder()
	check_label.visibility_changed.connect(
		func()->void:
			if check_label.visible:
				pass # play success sfx
	)
	ex_label.visibility_changed.connect(
		func()->void:
			if ex_label.visible:
				pass # play fail sfx
	)

func _clear_results_holder():
	card_a_result.visible = false
	card_b_result.visible = false
	check_label.visible = false
	ex_label.visible = false
	
func show_card_a(face_texture):
	var card_sprite: Sprite2D = $ResultCards/CardAResult/Sprite2D
	card_sprite.texture = face_texture
	card_a_result.visible = true
	
func show_card_b(face_texture):
	var card_sprite: Sprite2D = $ResultCards/CardBResult/Sprite2D
	card_sprite.texture = face_texture
	card_b_result.visible = true
