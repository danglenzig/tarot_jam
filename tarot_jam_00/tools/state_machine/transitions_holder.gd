#@tool
class_name TransitionHolder
extends Node

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	var has_at_least_one_transition := false
	var has_only_transition_nodes := true
	
	for child: Node in get_children():
		if child is StateTransition:
			has_at_least_one_transition = true
		else:
			has_only_transition_nodes = false
	
	if not has_at_least_one_transition:
		warnings.append("TransitionHolder needs at least one StateTransition child")
	if not has_only_transition_nodes:
		warnings.append(" TransitionHolder should only have StateTransition children")
	
	return warnings
