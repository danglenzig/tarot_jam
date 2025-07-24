class_name MemoryGame
extends Panel

@export var dev_mode := false

@onready var card_holder: GridContainer = $CardHolder
@onready var results_holder: MemoryResultsHolder = $ResultsHolder
@onready var continue_button: Button = $ContinueButton

@onready var dev_button: Button = $DevButton
@onready var take_hit_button: Button = $TakeHitButton


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
signal game_complete

const RESULT_DELAY := 0.25

func _ready() -> void:
	dev_button.visible = false
	take_hit_button.visible = false
	
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
	dev_button.pressed.connect(_on_dev_button_pressed)
	take_hit_button.pressed.connect(_on_take_hit_button_pressed)
	
	_set_up_game()
	
		
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
	if card_a.face_value == card_b.face_value:
		_on_success()
	else:
		_on_failure()
		
func _on_success():
	assert(
		selected_card_a_idx >= 0 and 
		selected_card_b_idx >= 0
	)
	await get_tree().create_timer(RESULT_DELAY).timeout
	results_holder.check_label.visible = true
	
	continue_button.visible = true
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
	
func _on_failure():
	assert(
		selected_card_a_idx >= 0 and 
		selected_card_b_idx >= 0
	)
	await get_tree().create_timer(RESULT_DELAY).timeout
	results_holder.ex_label.visible = true
	
	continue_button.visible = true
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

func _on_card_selected(card: MemoryGameCard):
	if selected_card_a_idx < 0:
		selected_card_a_idx = cards.find(card)
	else:
		selected_card_b_idx = cards.find(card)

func _on_dev_button_pressed():
	game_complete.emit()
func _on_take_hit_button_pressed():
	SingletonHolder.game_manager.take_hit("memory")
