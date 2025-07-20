#@tool
class_name StateHolder
extends Node

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	var has_at_least_one_state := false
	var has_only_state_nodes := true
	
	for child: Node in get_children():
		if child is State:
			has_at_least_one_state = true
		else:
			has_only_state_nodes = false
	
	if not has_at_least_one_state:
		warnings.append("StateHolder needs at least one State child")
	if not has_only_state_nodes:
		warnings.append("StateHolder should only have State children")
	
	return warnings
