class_name ThreeCardMonte
extends Panel

var ab_tween: Tween = null
var ba_tween: Tween = null

const SHUFFLE_TWEEN_DURATION := 0.33
const DISPLAY_CARDS_DURATION := 1.75

var round_one_shuffle_speed_modifier := 1.0

@export var dev_mode := false

@onready var card_holder: Node2D = $CardHolder
@onready var position_holder: Node2D = $PositionHolder
@onready var shuffle_button: Button = $ShuffleButton
@onready var dev_button: Button = $DevButton
@onready var take_hit_button: Button = $TakeHitButton
@onready var continue_button: Button = $ContinueButton




var round_number := -1
var round_over := false

var always_lose := false:
	set(new_value):
		always_lose = new_value

@warning_ignore("unused_signal")
signal continue_signal
signal shuffle_complete
signal round_complete(round_won: bool)
signal round_ready
#signal take_hit

var curently_active_card_uuid := "":
	set(new_value):
		curently_active_card_uuid = new_value
		#print_debug(curently_active_card_uuid)
		
var card_list: Array[MonteCard] = []
var position_list: Array[MontePosition] = []

var winning_card: MonteCard = null

func _ready() -> void:
	#dev_button.visible = false
	#take_hit_button.visible = false
	
	continue_button.visible = false
	
	shuffle_button.visible = false
	
	for child: Node in position_holder.get_children():
		position_list.append(child as MontePosition)
	
	for child: Node in card_holder.get_children():
		card_list.append(child as MonteCard)
		
	for card in card_list:
		
		card.game_controller = self
		card.win_signal.connect(_on_win_signal)
		card.lose_signal.connect(_on_lose_signal)
		if card.is_target_card:
			winning_card = card
		
	
	shuffle_button.pressed.connect(
		func()->void:
			shuffle_button.visible = false
			shuffle_cards()
	)
	#shuffle_complete.connect(
	#	func()->void: shuffle_button.visible = true
	#)
	_assign_face_texture_paths()
	_setup_cards()
	
	await display_all_cards_sequence()
	
	if winning_card:
		#print("FOOO")
		await winning_card.highlight_sequence(true)
	
	
	dev_button.visible = dev_mode
	#take_hit_button.visible = dev_mode
	#dev_button.pressed.connect(_on_dev_button_pressed)
	#take_hit_button.pressed.connect(_on_take_hit_pressed)
	
	
	
	
	shuffle_button.visible = true
	
	round_ready.emit()
	
	
func _setup_cards():
	# reparent each card to the card position whose start value
	# is the card's value
	for monte_pos in position_list:
		var this_pos_start_value = monte_pos.start_value
		for monte_card in card_list:
			if monte_card.value == this_pos_start_value:
				monte_card.reparent(monte_pos)
				monte_card.position = Vector2.ZERO
				break
				
	
func shuffle_cards():
	#for monte_card in card_list:
		#monte_card.select_enabled = false
	
	var swaps := randi_range(12,24)
	var swap_count := 0
	
	while  swap_count < swaps:
		
		# pick two positions
		var pos_idx_bucket := [0,1,2]
		var rando_a = pos_idx_bucket.pick_random()
		pos_idx_bucket.erase(rando_a)
		var rando_b = pos_idx_bucket.pick_random()
		pos_idx_bucket.clear()
		
		var pos_1 := position_list[rando_a]
		var pos_2 := position_list[rando_b]
		
		# at this point, each card position should have a direct
		# child, which is a card. 
		var pos_1_card: MonteCard = pos_1.find_children("*","MonteCard")[0]
		var pos_2_card: MonteCard = pos_2.find_children("*","MonteCard")[0]
		
		# get the tree name of each card's destination position
		#var pos_1_card_destination := pos_2.name
		#var pos_2_card_destination := pos_1.name
		
		# reparent pos_1_card to pos_1's PathFollow2D toward pos_1_card_destination
		var pos_1_card_path_name := str(
			"Path_",pos_1.name,"_",pos_2.name
		)
		assert(pos_1.has_node(pos_1_card_path_name))
		var pos_1_card_path := pos_1.get_node(pos_1_card_path_name) as Path2D
		var pos_1_card_path_follow := pos_1_card_path.get_node("PathFollow2D") as PathFollow2D
		pos_1_card.reparent(pos_1_card_path_follow)
		
		# and vice_versa
		var pos_2_card_path_name := str(
			"Path_",pos_2.name,"_",pos_1.name
		)
		assert(pos_2.has_node(pos_2_card_path_name))
		var pos_2_card_path := pos_2.get_node(pos_2_card_path_name) as Path2D
		var pos_2_card_path_follow := pos_2_card_path.get_node("PathFollow2D") as PathFollow2D
		pos_2_card.reparent(pos_2_card_path_follow)
		
		
		var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
		#sm.play_one_shot_sfx(sm.CARD_SLIDE)
		sm.play_card_shift()
		
		
		var duration_mod := randf_range(0.1, 0.2)
		if randi() % 2 == 0: duration_mod *= -1
		if duration_mod > 0:
			duration_mod *= 0.5
		
		var shuffle_dur = (SHUFFLE_TWEEN_DURATION + duration_mod) * round_one_shuffle_speed_modifier
		#print_debug(round_one_shuffle_speed_modifier)
		
		# tween pos_1_card to its destination
		_clear_tween(ab_tween)
		ab_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		ab_tween.tween_property(pos_1_card_path_follow, "progress_ratio", 1.0, shuffle_dur)
		
		await get_tree().create_timer(0.1).timeout
		
		# and vice versa
		_clear_tween(ba_tween)
		ba_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		ba_tween.tween_property(pos_2_card_path_follow, "progress_ratio", 1.0, shuffle_dur)
		
		# wait for the second one to finish
		await ba_tween.finished
		
		# reparent the cards to their new positions
		pos_1_card.reparent(pos_2)
		pos_1_card.position = Vector2.ZERO
		pos_1_card_path_follow.progress_ratio = 0.0
		pos_2_card.reparent(pos_1)
		pos_2_card.position = Vector2.ZERO
		pos_2_card_path_follow.progress_ratio = 0.0
		
		await get_tree().create_timer(0.05).timeout
		
		swap_count += 1
		
		
	for card in card_list:
		card._show_qm_label(true)
		
	_set_cards_selectable(true)
	
	
	
		
	shuffle_complete.emit()
	
	return true
		
func _clear_tween(tween: Tween):
	if tween:
		tween.kill()
		tween = null
		
func _assign_face_texture_paths():
	
	var symbol_number_bucket := []
	for i in range(SingletonHolder.deck_helper.face_up_data.keys().size()):
		symbol_number_bucket.append(i)
	
	# erase aces of Hearts
	symbol_number_bucket.erase(20)
	symbol_number_bucket.erase(21)
		
	for card in card_list:
		
		if card.is_target_card:
			var winner_face_texture_path = (
				# winner is allways Ace of Hearts
				SingletonHolder.deck_helper.face_up_data[20]["standard_face_texture_path"]
				#SingletonHolder.deck_helper.face_up_data[20]["texture_path"]
			)
			card.face_texture_path = winner_face_texture_path
		else:
			
			var rando_symol_idx = symbol_number_bucket.pick_random()
			symbol_number_bucket.erase(rando_symol_idx)
			var face_texture_path = (
				#SingletonHolder.deck_helper.face_up_data[rando_symol_idx]["texture_path"]
				SingletonHolder.deck_helper.face_up_data[rando_symol_idx]["standard_face_texture_path"]
			)
			card.face_texture_path = face_texture_path
			
			
			
#func _replace_tarot_with_standard_texture(number_of_cards):
#	pass
	
func _on_win_signal():
	
	for card in card_list:
		card._show_qm_label(false)
	
	#print_debug("WIN ROUND!")
	_set_cards_selectable(false)
	
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm.play_one_shot_sfx(sm.DA_DING)
	
	await winning_card.highlight_sequence(false)
	
	round_complete.emit(true)
	
func _on_lose_signal(losing_card: MonteCard):
	#print_debug("LOSE ROUND :/ ")
	
	for card in card_list:
		card._show_qm_label(false)
	
	_set_cards_selectable(false)
	
	await get_tree().create_timer(0.5).timeout
	
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	sm.play_one_shot_sfx(sm.BUZZ_2)
	
	await losing_card.display_x_sequence()
	
	round_complete.emit(false)
	
	
	
	
func _set_cards_selectable(selectable: bool):
	for card in card_list:
		card.select_enabled = selectable


func display_all_cards_sequence()->bool:
	
	for card in card_list:
		card._flip_card()
		await card.card_flip_complete
		
	await get_tree().create_timer(DISPLAY_CARDS_DURATION).timeout
	
	for card in card_list:
		card._flip_card()
		await card.card_flip_complete
		
	return true
