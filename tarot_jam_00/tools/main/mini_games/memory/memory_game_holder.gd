class_name MemoryGameHolder
extends Panel

@onready var label_holder: Node2D = $LabelHolder
@onready var round_number_label: Label = $LabelHolder/RoundNumberLabel


@onready var results_panel: Panel = $ResultsPanel
@onready var results_label_holder: Node2D = $ResultsPanel/ResultsLabelHolder
@onready var remaining_humanity_label: Label = $ResultsPanel/ResultsLabelHolder/RemainingHumanityLabel
@onready var results_comment_label: Label = $ResultsPanel/ResultsLabelHolder/ResultsCommentLabel

var round_label_tween: Tween = null
var results_label_tween: Tween = null

var round_number := 0

signal game_complete

#const TCM_SCENE: PackedScene = preload("res://game/main/mini_games/three_card_monte/three_card_monte.tscn")
const MG_SCENE: PackedScene = preload("res://game/main/mini_games/memory/memory_game.tscn")
const NUMBER_OF_ROUNDS := 3
const LABEL_TWEEN_DURATION := 0.25

func _ready() -> void:
	results_panel.visible = false
	round_number_label.visible = false
	round_number += 1
	
	# not using the round label here
	
	var new_game: MemoryGame = MG_SCENE.instantiate()
	call_deferred("add_child", new_game)
	await new_game.round_ready
	
	new_game.round_complete.connect(_on_round_complete) # trigger this in the game scrip
	new_game.dev_button.pressed.connect(_on_dev_button_pressed)
	new_game.take_hit_button.pressed.connect(_on_take_hit)
	new_game.take_hit.connect(_on_take_hit)
	
	


func _on_round_complete(total_guesses: int):
	var incorrect_guesses: int = total_guesses - 12
	var guesses_per_pair = float(total_guesses) / 12.0
	guesses_per_pair *= 1000
	guesses_per_pair = int(guesses_per_pair)
	guesses_per_pair = float(guesses_per_pair / 1000)
	
	await _clear_game()
	
	await _show_results_comment(total_guesses, incorrect_guesses, guesses_per_pair)
	await get_tree().create_timer(0.75).timeout
	await _show_remaining_humanity()
	await get_tree().create_timer(0.75).timeout
	
	results_panel.visible = false
	game_complete.emit()
	
	
func _show_results_comment(
	total_guesses: int,
	_incorrect_guesses: int,
	_guesses_per_pair: float
)->bool:
	
	
	var comment_string := str(
		"TOTAL\nGUESSES:\n",
		total_guesses
	)
	results_comment_label.text = comment_string
	await _tween_in_results_label(results_comment_label)
	await get_tree().create_timer(0.75).timeout
	return true

func _show_remaining_humanity()->bool:
	var remaining_percent = int(SingletonHolder.game_manager.hp / 10)
	
	var remaining_string = str(
		"REMAINING\n",
		"HUMANITY:\n",
		remaining_percent,"%"
	)
	remaining_humanity_label.text = remaining_string
	await _tween_in_results_label(remaining_humanity_label)
	await get_tree().create_timer(0.75).timeout
	return true

func _tween_in_results_label(label: Label):
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	
	if label == results_comment_label:
		results_comment_label.visible 		= true
		remaining_humanity_label.visible 	= false
	elif label == remaining_humanity_label:
		results_comment_label.visible 		= false
		remaining_humanity_label.visible 	= true
	else:
		push_error("Something weird happened")
		
	if results_label_tween:
		results_label_tween.kill()
		results_label_tween = null
		
	results_label_tween = create_tween()	
	results_label_holder.scale = Vector2(0.1, 0.1)
	results_panel.visible = true
	sm.tween_up_sine_tone(LABEL_TWEEN_DURATION)
	results_label_tween.tween_property(
		results_label_holder,
		"scale",
		Vector2(1.0,1.0),
		LABEL_TWEEN_DURATION
	)

func _clear_game()->bool:
	for child: Node in get_children():
		if child is MemoryGame:
			(child as MemoryGame).call_deferred("queue_free")
			await child.tree_exited
	return true

func _on_dev_button_pressed():
	game_complete.emit()
	
func _on_take_hit():
	SingletonHolder.game_manager.take_hit("memory")
	
