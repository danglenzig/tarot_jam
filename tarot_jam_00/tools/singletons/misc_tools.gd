
class_name MiscTools
extends Node

const FAILSAFE_COUNT := 100
const BUSY_WAIT := 0.05
const ENVIRONMENTS_FOLDER_PATH = "res://game/environments/"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func get_uuid()->String:
	var uuid = ""
	var chars = "0123456789abcdef"
	var sections = [8,4,4,4,12]
	for section in sections:
		for i in range(section):
			uuid += chars[randi() % chars.length()]
		if section != 12:
			uuid += "-"
	return uuid
	
func adjusted_z_index(y_pos: float)->int:
	return int(y_pos/10)
	
func to_snake_case(text: String) -> String:
	"""Converts a string to snake_case."""

	var result: String = ""
	var previous_was_upper: bool = false
	var previous_was_digit: bool = false

	for i in range(text.length()):
		var _char: String = text[i]
		if _char >= "A" and _char <= "Z": # is upper
			if i > 0 and not previous_was_upper:
				result += "_"
			result += _char.to_lower()
			previous_was_upper = true
			previous_was_digit = false
		elif _char >= "0" and _char <= "9": # is digit
			if i > 0 and not previous_was_upper and not previous_was_digit:
				result += "_"
			result += _char
			previous_was_upper = false
			previous_was_digit = true
		elif (_char >= "a" and _char <= "z") or (_char >= "A" and _char <= "Z"):# is alpha
			result += _char
			previous_was_upper = false
			previous_was_digit = false
		else:
			if _char != " ": #replace spaces with underscores, and ignore other non alphanumeric chars
				if i > 0 and result.length() >0 and result[result.length() -1] != "_":
					result += "_"
			previous_was_upper = false
			previous_was_digit = false

	# Remove leading and trailing underscores and double underscores.
	while result.begins_with("_"):
		result = result.substr(1)
	while result.ends_with("_"):
		result = result.substr(0,result.length() -1)
	while result.find("__") != -1:
		result = result.replace("__","_")
	return result
	
	
