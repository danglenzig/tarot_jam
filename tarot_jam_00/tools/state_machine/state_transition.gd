#@tool
class_name StateTransition
extends Node

@export var to_state: State:
	# refresh the config warning when the dev assigns a value in the inspector
	set(new_state):
		to_state = new_state
		update_configuration_warnings()

## if left blank, string will be: str(to_snake_case(self.name), "_event")
@export var event_string: String

@warning_ignore("unused_signal")
signal transition_taken

func _ready() -> void:
	if Engine.is_editor_hint(): return
	if event_string == "":
		event_string = str(SingletonHolder.misc_tools.to_snake_case(self.name), "_event")
	
	set_process(false)
	set_physics_process(false)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	# insert config checks
	if not to_state:
		warnings.append("Remember to assign a To State in the inspector")
	
	return warnings
