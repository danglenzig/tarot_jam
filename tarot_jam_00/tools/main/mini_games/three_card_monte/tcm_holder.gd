class_name TCMHolder
extends Panel

@onready var label_holder: Node2D = $LabelHolder
@onready var round_number_label: Label = $LabelHolder/RoundNumberLabel
#@onready var continue_button: Button = $ContinueButton

var round_label_tween: Tween = null

var round_number := 0

signal game_complete

const TCM_SCENE: PackedScene = preload("res://game/main/mini_games/three_card_monte/three_card_monte.tscn")

const NUMBER_OF_ROUNDS := 4
const LABEL_TWEEN_DURATION := 0.25


func _ready():
	
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
		print_debug("Round number ", round_number, " WON!")
		
	else:
		print_debug("Round nuumber ", round_number, " LOST :/")
		SingletonHolder.game_manager.take_hit("three_card_monte")
	
	var tcm: ThreeCardMonte = get_node("ThreeCardMonte")
	tcm.continue_button.visible = true
	await tcm.continue_button.pressed
	tcm.continue_button.visible = false
	
	await _clear_game()
	await get_tree().create_timer(1.0).timeout
	
	if round_number + 1 <= NUMBER_OF_ROUNDS:
		round_number += 1
		# play next round
		_load_game()
	else:
		# do whatever needs doing
		game_complete.emit()


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
	
	
	
	
	
