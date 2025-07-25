class_name MastermindHolder
extends Panel

@onready var label_holder: Node2D = $LabelHolder
@onready var round_number_label: Label = $LabelHolder/RoundNumberLabel
@onready var results_panel: Panel = $ResultsPanel
@onready var results_label_holder: Node2D = $ResultsPanel/ResultsLabelHolder
@onready var solved_in_n_guesses_label: Label = $ResultsPanel/ResultsLabelHolder/SolvedInNGuessesLabel
#@onready var humanity_lost_label: Label = $ResultsPanel/ResultsLabelHolder/HumanityLostLabel
@onready var remaining_humanity_label: Label = $ResultsPanel/ResultsLabelHolder/RemainingHumanityLabel


var round_label_tween: Tween = null
var results_label_tween: Tween = null

var round_number := 0

signal game_complete

const MASTERMIND_GAME = preload("res://game/main/mini_games/mastermind/MastermindGame.tscn")

const NUMBER_OF_ROUNDS := 4
const LABEL_TWEEN_DURATION := 0.25

@onready var starting_hp: float = SingletonHolder.game_manager.hp

func _ready() -> void:
	results_panel.visible = false
	round_number_label.visible = false
	_load_game()
	
func _load_game()->bool:
	
	round_number += 1
	
	await _clear_game()
	await _tween_in_round_label(round_number)
	
	var new_game: MastermindGame = MASTERMIND_GAME.instantiate()
	call_deferred("add_child", new_game)
	
	await new_game.tree_entered
	#new_game.holder = self
	
	await new_game.round_ready
	
	new_game.round_number = round_number
	new_game._assign_symbol_sprites()
	
	
	new_game.round_complete.connect(_on_round_complete)
	new_game.dev_button.pressed.connect(_on_dev_button_pressed)
	new_game.take_hit_button.pressed.connect(_on_take_hit)
	
	
	
	return true
	
func _clear_game()->bool:
	for child: Node in get_children():
		if child is MastermindGame:
			(child as MastermindGame).call_deferred("queue_free")
			await child.tree_exited
	return true
	
func _on_round_complete(attempts: int):
	print("Round ", round_number, " solved in ", attempts, " guesses.")
	
	await get_tree().create_timer(1.0).timeout
	
	if round_number + 1 > NUMBER_OF_ROUNDS:
		
		await _display_round_results(attempts)
		game_complete.emit()
	else:
		
		await _display_round_results(attempts)
		_load_game()


func _display_round_results(attempts)->bool:
	
	var mm: MastermindGame = get_node("MastermindGame")
	mm.visible = false
	
	solved_in_n_guesses_label.visible = false
	remaining_humanity_label.visible = false
	
	results_panel.visible = true
	
	
	var solved_in_string := str(
		"SOLVED IN\n",
		attempts,"\n",
		"GUESSES"
	)
	solved_in_n_guesses_label.text = solved_in_string
	await _tween_in_results_label(solved_in_n_guesses_label)
	for i in range(attempts):
		SingletonHolder.game_manager.take_hit("mastermind")
		await get_tree().create_timer(0.1).timeout
		
	await get_tree().create_timer(1.0).timeout
	
	solved_in_n_guesses_label.visible = false

	var remaining_percent = int(SingletonHolder.game_manager.hp / 10) 
	var remaining_string = str(
		"REMAINING\n",
		"HUMANITY:\n",
		remaining_percent,"%"
	)
	remaining_humanity_label.text = remaining_string
	await _tween_in_results_label(remaining_humanity_label)
	
	await get_tree().create_timer(1.0).timeout
	
	remaining_humanity_label.visible = false
	
	results_panel.visible = false
	
	return true
	
func _tween_in_results_label(label: Label)->bool:
	var sm = SingletonHolder.game_manager.main.sound_manager
	results_label_holder.scale = Vector2(0.1, 0.1)
	if results_label_tween:
		results_label_tween.kill()
		results_label_tween = null
	results_label_tween = create_tween()
	
	sm.tween_up_sine_tone(LABEL_TWEEN_DURATION)
	label.visible = true
	results_label_tween.tween_property(
		results_label_holder,
		"scale",
		Vector2(1.0, 1.0),
		LABEL_TWEEN_DURATION
	)
	await results_label_tween.finished
	
	sm.play_one_shot_sfx(sm.BELL)
	
	return true

func _tween_in_round_label(round_value)->bool:
	label_holder.scale = Vector2(0.1, 0.1)
	round_number_label.text = str("ROUND ",round_value)
	round_number_label.visible = true
	
	if round_label_tween:
		round_label_tween.kill()
		round_label_tween = null
	
	round_label_tween = create_tween()
	
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm.tween_up_sine_tone(LABEL_TWEEN_DURATION)
	round_label_tween.tween_property(
		label_holder,
		"scale",
		Vector2(1.0, 1.0),
		LABEL_TWEEN_DURATION
	)
	await round_label_tween.finished
	sm.play_one_shot_sfx(sm.BELL)
	
	await get_tree().create_timer(0.5).timeout
	
	round_number_label.visible = false

	return true

func _on_dev_button_pressed():
	game_complete.emit()
	
func _on_take_hit():
	SingletonHolder.game_manager.take_hit("mastermind")
