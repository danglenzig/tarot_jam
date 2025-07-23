class_name MastermindSolutionHolder
extends GridContainer

var solution_array: Array[MastermindSolutionSlot] = []

func _ready() -> void:
	for slot in get_children():
		if slot not in solution_array:
			solution_array.append(slot as MastermindSolutionSlot)
