class_name MiniGameManager
extends Node2D

const game_paths := {
	"mastermind": "res://game/main/mini_games/mastermind/MastermindGame.tscn",
	"memory": "res://game/main/mini_games/memory/memory_game_card.tscn",
	"three_card_monte": "res://game/main/mini_games/three_card_monte/three_card_monte.tscn",
}

func clear_minigame()->bool:
	for child in get_children():
		child.call_deferred("queue_free")
		await child.tree_exited
	return true
