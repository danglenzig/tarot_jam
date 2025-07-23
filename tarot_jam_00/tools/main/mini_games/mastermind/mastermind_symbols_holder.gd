class_name MastermindSymbolsHolder
extends GridContainer

var symbols_array: Array[MastermindCard] = []

func _ready()->void:
	for card in get_children():
		if card not in symbols_array:
			symbols_array.append(card as MastermindCard)
