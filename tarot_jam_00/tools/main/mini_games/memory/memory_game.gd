class_name MemoryGame
extends Panel

@export var dev_mode := false

@onready var card_holder: GridContainer = $CardHolder
@onready var results_holder: MemoryResultsHolder = $ResultsHolder
@onready var continue_button: Button = $ContinueButton

@onready var dev_button: Button = $DevButton
@onready var take_hit_button: Button = $TakeHitButton

#var incorrect_guesses := 0
var total_guesses := 0

var listen_for_click := false

var cards: Array[MemoryGameCard] = []

var selected_card_a_idx := -1:
	set(new_value):
		selected_card_a_idx = new_value
		if selected_card_a_idx >= 0:
			first_card_selected.emit()

var selected_card_b_idx := -1:
	set(new_value):
		selected_card_b_idx = new_value
		if selected_card_b_idx >= 0:
			second_card_selected.emit()

var current_card_hovered_uuid := "":
	set(new_value):
		current_card_hovered_uuid = new_value

signal first_card_selected
signal second_card_selected
signal continue_signal

signal game_complete # remove this

signal round_complete
signal round_ready

signal take_hit

const RESULT_DELAY := 0.25
const AUTO_CONTINUE := 2.5

func _ready() -> void:
	dev_button.visible = false
	take_hit_button.visible = false
	
	listen_for_click = false

	continue_button.visibility_changed.connect(
		func()->void:
			listen_for_click = continue_button.visible
	)
	
	continue_button.visible = false
	continue_button.pressed.connect(
		func()->void:
			continue_button.visible = false
			continue_signal.emit()
	)
	second_card_selected.connect(_on_second_card_selected)
	first_card_selected.connect(_on_first_card_selected)
	
	for child in card_holder.get_children():
		cards.append(child as MemoryGameCard)
	
	for card in cards:
		card.face_up = false
		card.game_controller = self
		card.card_selected.connect(_on_card_selected)
		
		
	#SingletonHolder.event_bus.start_minigame.connect(
	#	func()->void:
	#	await _set_up_game()
	#)
	
	dev_button.visible = dev_mode
	take_hit_button.visible = dev_mode
	#dev_button.pressed.connect(_on_dev_button_pressed)
	take_hit_button.pressed.connect(_on_take_hit_button_pressed)
	
	await _set_up_game()
	
	round_ready.emit()
		
func _set_up_game()->bool:
	
	print_debug("FFFFFFFFFOOOOOOOOOOO")
	
	var possible_card_values = []
	for i in range(SingletonHolder.deck_helper.face_up_data.keys().size()):
		possible_card_values.append(i)
		
	for card in cards:
		if card.face_up:
			await card.flip_to_face_down()
			
	var card_positions = []
	for i in range(cards.size()):
		card_positions.append(i)
	
	
	while card_positions.size() > 0:
		
		assert(card_positions.size() % 2 == 0) # should be an even number
		
		# pick two card positions
		var card_pos_a = card_positions.pick_random()
		card_positions.erase(card_pos_a)
		var card_pos_b = card_positions.pick_random()
		card_positions.erase(card_pos_b)
		
		# pick a face value for this pair
		var pair_value = possible_card_values.pick_random()
		possible_card_values.erase(pair_value)
		
		# assign the value to the card pair
		cards[card_pos_a].face_value = pair_value
		cards[card_pos_b].face_value = pair_value
		
		cards[card_pos_a].flip_to_face_up()
		await cards[card_pos_b].flip_to_face_up()
		
		await get_tree().create_timer(0.1).timeout
	
	await get_tree().create_timer(1.0).timeout
	
	for card in cards:
		await card.flip_to_face_down()
	
	
	
	
	for card in cards:
		card.selectable = true
		card.select_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	
	return true

func _on_first_card_selected():
	assert(selected_card_a_idx >= 0)
	var selected_card: MemoryGameCard = cards[selected_card_a_idx]
	results_holder.show_card_a(selected_card.card_sprite.texture)
	
func _on_second_card_selected():
	assert(selected_card_b_idx >= 0)
	var selected_card: MemoryGameCard = cards[selected_card_b_idx]
	results_holder.show_card_b(selected_card.card_sprite.texture)
	for card in cards:
		card.selectable = false
	_check_result()
		
func _check_result():
	assert(
		selected_card_a_idx >= 0 and 
		selected_card_b_idx >= 0
	)
	var card_a: MemoryGameCard = cards[selected_card_a_idx]
	var card_b: MemoryGameCard = cards[selected_card_b_idx]
	total_guesses += 1
	if card_a.face_value == card_b.face_value:
		_on_success()
	else:
		_on_failure()

func _timeout_continue():
	await get_tree().create_timer(AUTO_CONTINUE).timeout
	if not listen_for_click: return
	continue_signal.emit()
	

func _on_success():
	assert(
		selected_card_a_idx >= 0 and 
		selected_card_b_idx >= 0
	)
	await get_tree().create_timer(RESULT_DELAY).timeout
	results_holder.check_label.visible = true
	
	continue_button.visible = true
	_timeout_continue()
	await continue_signal
	
	var card_a = cards[selected_card_a_idx]
	var card_b = cards[selected_card_b_idx]
	
	card_a.remove_card() # add disolve effect 
	await card_b.remove_card()
	
	results_holder._clear_results_holder()
	
	selected_card_a_idx = -1
	selected_card_b_idx = -1
	
	for card in cards:
		card.selectable = true
		
	_check_if_game_over()
	
func _on_failure():
	assert(
		selected_card_a_idx >= 0 and 
		selected_card_b_idx >= 0
	)
	await get_tree().create_timer(RESULT_DELAY).timeout
	results_holder.ex_label.visible = true
	
	continue_button.visible = true
	_timeout_continue()
	await continue_signal
	
	results_holder._clear_results_holder()
	
	var card_a = cards[selected_card_a_idx]
	var card_b = cards[selected_card_b_idx]
	
	await card_a.flip_to_face_down()
	await card_b.flip_to_face_down()
	
	selected_card_a_idx = -1
	selected_card_b_idx = -1
	
	for card in cards:
		card.selectable = true
	
	#incorrect_guesses += 1
	take_hit.emit()
	
	_check_if_game_over()

func _check_if_game_over():
	var game_over := true
	for card in cards:
		if card.card_sprite.visible:
			game_over = false
			break
	if game_over:
		round_complete.emit(total_guesses)

func _on_card_selected(card: MemoryGameCard):
	if selected_card_a_idx < 0:
		selected_card_a_idx = cards.find(card)
	else:
		selected_card_b_idx = cards.find(card)

#func _on_dev_button_pressed():
	#game_complete.emit()
func _on_take_hit_button_pressed():
	SingletonHolder.game_manager.take_hit("memory")
	
func _input(event: InputEvent) -> void:
	if not listen_for_click: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				continue_signal.emit()
