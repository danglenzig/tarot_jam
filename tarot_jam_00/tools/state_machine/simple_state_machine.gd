#@tool
class_name SimpleStateMachine
extends Node

var states: Array[State]
@onready var states_holder: StateHolder = $StateHolder
@onready var transitions_holder: TransitionHolder = $TransitionHolder

@export var initial_state: State:
	set(new_value):
		initial_state = new_value
		update_configuration_warnings()

@export var state_history_size: int = 10

var current_state: State = null
var state_history: Array[State]


func _ready() -> void:
	if Engine.is_editor_hint(): return
	state_history_size = clamp(state_history_size, 1, 100)
	for state in states_holder.get_children():
		if not state is State:
			push_error("That's not a State")
		states.append(state as State)
	current_state = initial_state
	
	set_process(false)
	set_physics_process(false)
	
	
func send_event(event_string):
	var next_state: State = null
	for transition: StateTransition in current_state.transitions:
		if transition.event_string == event_string:
			next_state = transition.to_state
			transition.transition_taken.emit()
			break
			
	if not next_state:
		push_warning("State ",current_state.name, " has no transition with event string ", event_string)
		return
	
	assert(next_state in states)
	_update_state_history(current_state)
	current_state = next_state
	current_state.on_enter()
	
func _update_state_history(last_state: State):
	last_state.on_exit()
	if state_history.size() + 1 > state_history_size:
		state_history.pop_front()
	state_history.append(last_state)
	

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	if not initial_state:
		warnings.append("Remember to configure an initial state")
	
	var has_state_holder := false
	var has_transition_holder := false
	
	for child: Node in get_children():
		if child is StateHolder:
			has_state_holder = true
		if child is TransitionHolder:
			has_transition_holder = true
	if not has_state_holder:
		warnings.append("Add a StateHolder")
	if not has_transition_holder:
		warnings.append("Add a TransitionHolder")
		
	return warnings
