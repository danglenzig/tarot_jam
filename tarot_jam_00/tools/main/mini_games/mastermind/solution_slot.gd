class_name MastermindSolutionSlot
extends Control

enum SolutionSlotState {
	EMPTY,
	UNDETERMINED,
	CORRECT,
	WRONG_POSITION,
	INCORRECT
}

@onready var solution_rect: ColorRect = $SolutionRect
@onready var sprite_2d: Sprite2D = $SolutionRect/Sprite2D
@onready var slot_uuid: String = SingletonHolder.misc_tools.get_uuid()

var game_controller: MastermindGame = null:
	set(new_value):
		game_controller = new_value
		if game_controller:
			controller_ready.emit()

var slot_state: SolutionSlotState = SolutionSlotState.EMPTY:
	set(new_value):
		slot_state = new_value
		match slot_state:
			0: # EMPTY
				solution_rect.color = default_color
				sprite_2d.texture = null
				currently_placed_symbol_idx = -1
				solution_rect.mouse_filter = Control.MOUSE_FILTER_STOP
			1: # UNDETERMINED
				solution_rect.color = default_color
				solution_rect.mouse_filter = Control.MOUSE_FILTER_STOP
			2: # CORRECT
				solution_rect.color = Color.GREEN
			3: # WRONG_POSITION
				solution_rect.color = Color.GOLD
			4: # INCORRECT
				solution_rect.color = Color.RED

var rect_correct_symbol_idx := -1:
	set(new_value):
		rect_correct_symbol_idx = new_value
		if rect_correct_symbol_idx >= 0:
			#print_debug(name, " is looking for idx ", rect_correct_symbol_idx)
			pass
var currently_placed_symbol_idx := -1

var default_color := Color.GRAY

signal controller_ready



func _ready() -> void:
	await  controller_ready
	default_color = solution_rect.color
	
	solution_rect.mouse_entered.connect(
		func()->void:
			if game_controller.active_solution_rect_uuid != "": return
			game_controller.active_solution_rect_uuid = slot_uuid
	)
	solution_rect.mouse_exited.connect(
		func()->void:
			if game_controller.active_solution_rect_uuid != slot_uuid: return
			game_controller.active_solution_rect_uuid = ""
	)
	
	game_controller.symbol_dropped.connect(_on_symbol_dropped)

func _on_symbol_dropped(_uuid: String, idx: int):
	if game_controller.active_solution_rect_uuid != slot_uuid: return
	if currently_placed_symbol_idx >= 0: return
	
	currently_placed_symbol_idx = idx
	var texture = game_controller.get_texture_of_symbol_at_idx(idx)
	sprite_2d.texture = texture
	game_controller.symbol_placed.emit(idx)

func check_solution():
	assert(currently_placed_symbol_idx >= 0)
	if currently_placed_symbol_idx == rect_correct_symbol_idx:
		slot_state = SolutionSlotState.CORRECT
	elif currently_placed_symbol_idx in game_controller.puzzle_solution:
		slot_state = SolutionSlotState.WRONG_POSITION
	else:
		slot_state = SolutionSlotState.INCORRECT
		
func on_continue():
	match slot_state:
		#0: # EMPTY
		#	assert(true, "this should never happen")
		#1: # UNDETERMINED
		#	assert(true, "this should never happen")
		2: # CORRECT
			pass # leave it be
		3: # WRONG_POSITION
			game_controller.put_back_wrong_position_symbol(currently_placed_symbol_idx)
			slot_state = SolutionSlotState.EMPTY
		4: # INCORRECT
			game_controller.put_back_incorrect_symbol(currently_placed_symbol_idx)
			slot_state = SolutionSlotState.EMPTY
