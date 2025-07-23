class_name ThreeCardMonte
extends Panel

var ab_tween: Tween = null
var ba_tween: Tween = null

const SHUFFLE_TWEEN_DURATION := 0.1

@onready var card_holder: Node2D = $CardHolder
@onready var position_holder: Node2D = $PositionHolder
@onready var shuffle_button: Button = $ShuffleButton

var round_number := -1

var curently_active_card_uuid := "":
	set(new_value):
		curently_active_card_uuid = new_value
		print_debug(curently_active_card_uuid)
		
var card_list: Array[MonteCard] = []
var position_list: Array[MontePosition] = []

signal continue_signal
signal shuffle_complete

func _ready() -> void:
	for child: Node in position_holder.get_children():
		position_list.append(child as MontePosition)
	
	for child: Node in card_holder.get_children():
		card_list.append(child as MonteCard)
		
	for card in card_list:
		
		card.game_controller = self
	
	shuffle_button.pressed.connect(
		func()->void:
			shuffle_button.visible = false
			shuffle_cards()
	)
	shuffle_complete.connect(
		func()->void: shuffle_button.visible = true
	)
	_assign_face_texture_paths()
	_setup_cards()
	
	
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
	for monte_card in card_list:
		monte_card.select_enabled = false
		
	# await flip all three cards face down
	
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
		var pos_1_card_destination := pos_2.name
		var pos_2_card_destination := pos_1.name
		
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
		
		# tween pos_1_card to its destination
		_clear_tween(ab_tween)
		ab_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		ab_tween.tween_property(pos_1_card_path_follow, "progress_ratio", 1.0,SHUFFLE_TWEEN_DURATION)
		
		await get_tree().create_timer(0.1).timeout
		
		# and vice versa
		_clear_tween(ba_tween)
		ba_tween = create_tween().set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
		ba_tween.tween_property(pos_2_card_path_follow, "progress_ratio", 1.0, SHUFFLE_TWEEN_DURATION)
		
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
		card.select_enabled = true
		
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
	for card in card_list:
		var rando_symol_idx = symbol_number_bucket.pick_random()
		symbol_number_bucket.erase(rando_symol_idx)
		var face_texture_path = SingletonHolder.deck_helper.face_up_data[rando_symol_idx]["texture_path"]
		card.face_texture_path = face_texture_path
		
	match round_number:
		0:
			pass
		1:
			pass
		2:
			pass
		3:
			pass
		_:
			pass
			
func _replace_tarot_with_standard_texture(number_of_cards):
	pass
