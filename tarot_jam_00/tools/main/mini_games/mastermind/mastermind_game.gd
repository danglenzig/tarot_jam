class_name MastermindGame
extends Panel

@export var dev_mode := false

@onready var symbols_holder: MastermindSymbolsHolder = $SymbolsHolder
@onready var solution_holder: MastermindSolutionHolder = $SolutionHolder
@onready var mouse_chaser: MouseChaser = $MouseChaser
@onready var continue_button: Button = $ContinueButton
@onready var dev_button: Button = $DevButton
@onready var take_hit_button: Button = $TakeHitButton

#signal holder_ready
#var holder: MastermindHolder = null:
#	set(new_value):
#		holder = new_value
#		if holder:
#			holder_ready.emit()

var listen_for_click := false

var round_number := 0:
	set(new_value):
		round_number = new_value


var puzzle_solution: Array[int]

var currently_holding_symbol_idx := -1


var select_mode := true
var checking := false

var active_solution_rect_uuid := "":
	set(new_value):
		active_solution_rect_uuid = new_value
		#print_debug(active_solution_rect_uuid)

var active_symbol_rect_uuid := "":
	set(new_value):
		active_symbol_rect_uuid = new_value
		#print_debug(active_symbol_rect_uuid)

var attempts := 0:
	set(new_value):
		attempts = new_value
		#print_debug("Attempts: ", attempts)
		
signal symbol_dropped(uuid: String, symbol_idx: String)
signal symbol_placed(symbol_idx: String)
signal symbol_clicked(symbol_uuid)
#signal puzzle_solved
#signal game_complete

signal round_complete(round_tries_result: int)
signal round_ready

func _ready() -> void:
	
	dev_button.visible = false
	take_hit_button.visible = false
	
	continue_button.visible = false
	continue_button.visibility_changed.connect(
		func()->void:
			listen_for_click = continue_button.visible
	)
	
	
	for symbol in symbols_holder.symbols_array:
		symbol.game_controller = self
	for slot in solution_holder.solution_array:
		slot.game_controller = self
	
	
	
	symbol_clicked.connect(_on_symbol_clicked)
	symbol_placed.connect(_on_symbol_placed)
	continue_button.pressed.connect(_on_continue_pressed)
	
	puzzle_solution = _get_random_solution()
	print_debug("The solution is: ", puzzle_solution)
	_assign_solution_values(puzzle_solution)
	
	dev_button.visible = dev_mode
	take_hit_button.visible = dev_mode
	
	#await holder_ready
	#round_number = holder.round_number
	
	#_assign_symbol_sprites()
	
	round_ready.emit()
	
	

func _assign_solution_values(solution: Array[int]):
	assert(solution.size() == 4)
	for i in range(4):
		solution_holder.solution_array[i].rect_correct_symbol_idx = solution[i]

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_released():
				if currently_holding_symbol_idx < 0 : return
				
				var held_card = symbols_holder.symbols_array[currently_holding_symbol_idx]
				symbol_dropped.emit(held_card.card_uuid, currently_holding_symbol_idx)
				
				mouse_chaser.texture = null
				mouse_chaser.visible = false
				currently_holding_symbol_idx = -1
				select_mode = true
				
		#if event.button_index == MOUSE_BUTTON_RIGHT:
		#	if event.is_pressed():
		#		if not listen_for_click: return
		#		_on_continue_pressed()
				
func _on_symbol_clicked(uuid: String):
	assert(currently_holding_symbol_idx == -1, "Something weid happened")
	assert(active_symbol_rect_uuid == uuid, "Something weird happened")
	for card in symbols_holder.symbols_array:
		if card.card_uuid == uuid:
			currently_holding_symbol_idx = symbols_holder.symbols_array.find(card)
			#print_debug("currently holding card number ", currently_holding_symbol_idx)
			break
			
func _get_random_solution()->Array[int]:
	var rando_solution: Array[int] = []
	
	var symbol_indexes := []
	for i in range(symbols_holder.symbols_array.size()):
		symbol_indexes.append(i)
		
	while rando_solution.size() < 4:
		var this_idx = symbol_indexes.pick_random()
		symbol_indexes.erase(this_idx)
		rando_solution.append(this_idx)
	
	return rando_solution

func _on_symbol_placed(idx):
	var this_symbol: MastermindCard = symbols_holder.symbols_array[idx]
	this_symbol.select_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	this_symbol.sprite_2d.self_modulate.a = 0.0
	
	if _check_if_last():
		_read_current_solution()
		
	# TODO (maybe?):
	# if the number of empty slots is less <= the number of
	# "yellow" symbols, this disable selection on the rest.
	
	

func get_texture_of_symbol_at_idx(idx: int)->Texture:
	assert(symbols_holder.symbols_array[idx])
	return symbols_holder.symbols_array[idx].sprite_2d.texture

func _check_if_last()->bool:
	var count := 0
	for slot in solution_holder.solution_array:
		if slot.currently_placed_symbol_idx >= 0:
			count += 1
	return (count >= 4)
	
func _read_current_solution():
	
	
	# disable all the rects
	for symbol: MastermindCard in symbols_holder.symbols_array:
		symbol.select_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	for slot in solution_holder.solution_array:
		slot.solution_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		
	# clear the puzzle state
	active_solution_rect_uuid = ""
	active_symbol_rect_uuid = ""
	currently_holding_symbol_idx = -1
	select_mode = false
	mouse_chaser.texture = null
	mouse_chaser.visible = false
	
	symbols_holder.modulate.a = 0.5
	
	var correct_symbols := 0
	for slot in solution_holder.solution_array:
		slot.check_solution()
		if slot.slot_state == slot.SolutionSlotState.CORRECT:
			correct_symbols += 1
	
	if correct_symbols >= 4:
		_on_puzzle_solved()
		return
		
	attempts += 1
	#SingletonHolder.game_manager.take_hit("mastermind")
	continue_button.visible = true

func _on_puzzle_solved():
	#puzzle_solved.emit()
	round_complete.emit(attempts)
	
func _on_continue_pressed():
	continue_button.visible = false
	
	# if the symbol wasn't touched this roundm then re-enable it
	for symbol in symbols_holder.symbols_array:
		if symbol.sprite_2d.self_modulate.a == 1.0:
			symbol.select_rect.mouse_filter = Control.MOUSE_FILTER_STOP
			
	for slot in solution_holder.solution_array:
		slot.on_continue()
		
	symbols_holder.modulate.a = 1.0
	
func put_back_wrong_position_symbol(idx: int):
	var this_symbol = symbols_holder.symbols_array[idx]
	this_symbol.select_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	this_symbol.highlight_color_rect.color = Color.GOLD
	this_symbol.sprite_2d.self_modulate.a = 1.0
	
func put_back_incorrect_symbol(idx: int):
	var this_symbol = symbols_holder.symbols_array[idx]
	#this_symbol.select_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	this_symbol.highlight_color_rect.color = Color.RED
	this_symbol.sprite_2d.self_modulate.a = 0.5
	
func _assign_symbol_sprites():
	
	var symbol_number_bucket := []
	for i in range(
		SingletonHolder.deck_helper.face_up_data.keys().size()
	):
		symbol_number_bucket.append(i)
	
	for symbol in symbols_holder.symbols_array:
		var symbol_number = symbol_number_bucket.pick_random()
		symbol_number_bucket.erase(symbol_number)
		var texture = load(
			SingletonHolder.deck_helper.face_up_data[symbol_number]["texture_path"]
		)
		symbol.sprite_2d.texture = texture
	
	
	match round_number:
		# replace 12, 8, 4, or zero textures with standard face
		# cards depending on round number
		1:
			_replace_tarot_sprites_with_standard_sprites(12)
		2:
			_replace_tarot_sprites_with_standard_sprites(8)
		3:
			_replace_tarot_sprites_with_standard_sprites(4)
		4:
			pass # all tarot
		_:
			pass # all tarot
	
func _replace_tarot_sprites_with_standard_sprites(number_to_change):
	var symbol_number_bucket := []
	var card_number_bucket := []
	for i in range(symbols_holder.symbols_array.size()):
		symbol_number_bucket.append(i)
	for i in range(SingletonHolder.deck_helper.face_up_data.keys().size()):
		card_number_bucket.append(i)
	for i in range(number_to_change):
		var rando_symbol_number = symbol_number_bucket.pick_random()
		symbol_number_bucket.erase(rando_symbol_number)
		var rando_card_number = card_number_bucket.pick_random()
		card_number_bucket.erase(rando_card_number)
		var standard_texture = load(
			SingletonHolder.deck_helper.face_up_data[rando_card_number]["standard_face_texture_path"]
		)
		symbols_holder.symbols_array[rando_symbol_number].sprite_2d.texture = standard_texture
		
#func _on_dev_button_pressed():
#	game_complete.emit()
#func _on_take_hit_button_pressed():
#	SingletonHolder.game_manager.take_hit("mastermind")
