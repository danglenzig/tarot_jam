class_name TCMHolder
extends Panel

@onready var label_holder: Node2D = $LabelHolder
@onready var round_number_label: Label = $LabelHolder/RoundNumberLabel
#@onready var continue_button: Button = $ContinueButton

@onready var results_panel: Panel = $ResultsPanel
@onready var results_label_holder: Node2D = $ResultsPanel/ResultsLabelHolder
@onready var remaining_humanity_label: Label = $ResultsPanel/ResultsLabelHolder/RemainingHumanityLabel
@onready var results_comment_label: Label = $ResultsPanel/ResultsLabelHolder/ResultsCommentLabel


var round_label_tween: Tween = null
var results_label_tween: Tween = null

var round_number := 0

signal game_complete

const TCM_SCENE: PackedScene = preload("res://game/main/mini_games/three_card_monte/three_card_monte.tscn")

const NUMBER_OF_ROUNDS := 3
const LABEL_TWEEN_DURATION := 0.25


func _ready():
	results_panel.visible = false
	round_number_label.visible = false
	
	round_number += 1
	
	_load_game()

func _load_game()->bool:
	await _clear_game()
	
	await _tween_in_round_label(round_number)
	
	var new_game: ThreeCardMonte = TCM_SCENE.instantiate()
	call_deferred("add_child", new_game)
	await new_game.round_ready
		
	new_game.round_number = round_number
	
	if round_number == NUMBER_OF_ROUNDS:
		new_game.always_lose = true
	
	new_game.round_complete.connect(_on_round_complete)
	new_game.dev_button.pressed.connect(_on_dev_button_pressed)
	new_game.take_hit_button.pressed.connect(_on_take_hit)
	new_game.take_hit.connect(_on_take_hit)
	
	return true
	
func _clear_game()->bool:
	for child: Node in get_children():
		if child is ThreeCardMonte:
			(child as ThreeCardMonte).call_deferred("queue_free")
			await child.tree_exited
	return true
	
func _on_round_complete(round_won: bool):
	## temp
	if round_won:
		#print_debug("Round number ", round_number, " WON!")
		pass
		
	else:
		#print_debug("Round nuumber ", round_number, " LOST :/")
		SingletonHolder.game_manager.take_hit("three_card_monte")
	
	var tcm: ThreeCardMonte = get_node("ThreeCardMonte")
	tcm.continue_button.visible = true
	await tcm.continue_button.pressed
	tcm.continue_button.visible = false
	
	await _clear_game()
	
	if round_number + 1 <= NUMBER_OF_ROUNDS:
		
		# play next round
		
		await _show_results_comment(round_won)
		await get_tree().create_timer(0.75).timeout
		await _show_remaining_humanity_label()
		await get_tree().create_timer(0.75).timeout
		
		results_panel.visible = false
		
		round_number += 1
		
		_load_game()
	else:
		await _show_results_comment(round_won)
		await get_tree().create_timer(0.75).timeout
		await _show_remaining_humanity_label()
		await get_tree().create_timer(0.75).timeout
		
		results_panel.visible = false
		game_complete.emit()


func _show_remaining_humanity_label()-> bool:
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

func _show_results_comment(round_won: bool)->bool:
	
	
	print_debug("RESULTS FOR ROUND NUMBER ", round_number)
	
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager

	
	var comment_string := ""
	
	if round_won:
		comment_string = "AREN'T\nYOU\nSMART!"
		sm.play_audience_reaction(sm.APPLAUSE_01)
	else:
		if round_number < NUMBER_OF_ROUNDS:
			comment_string = "TRY\nHARDER!"
			sm.play_audience_reaction(sm.BOO)
		else:
			comment_string = "DON'T BE\nA\nFOOL!"
			sm.play_audience_reaction(sm.LAUGH)
			
	results_comment_label.text = comment_string
	await _tween_in_results_label(results_comment_label)
	await get_tree().create_timer(0.75).timeout
	
	return true
	
	
func _tween_in_results_label(label: Label) -> bool:
	
	results_panel.visible = true
	
	if label == results_comment_label:
		results_comment_label.visible = true
		remaining_humanity_label.visible = false
	elif label == remaining_humanity_label:
		results_comment_label.visible = false
		remaining_humanity_label.visible = true
	else: push_error("Something weird happened")
		
	
	if results_label_tween:
		results_label_tween.kill()
		results_label_tween = null
	results_label_holder.scale = Vector2(0.1, 0.1)
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm.tween_up_sine_tone(LABEL_TWEEN_DURATION)
	results_label_tween = create_tween()
	results_label_tween.tween_property(
		results_label_holder,
		"scale",
		Vector2(1.0, 1.0),
		LABEL_TWEEN_DURATION
	)
	await results_label_tween.finished
	
	return true
	

func _on_dev_button_pressed():
	game_complete.emit()
	
func _on_take_hit():
	SingletonHolder.game_manager.take_hit("three_card_monte")

func _tween_in_round_label(round_value: int)->bool:
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
	
	
	
	
	
