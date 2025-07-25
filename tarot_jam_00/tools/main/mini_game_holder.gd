class_name MiniGameManager
extends Node2D

enum MiniGames {THREE_CARD_MONTE, MASTERMIND, MEMORY}

var game_env: GameEnvironment = null:
	set(new_value):
		game_env = new_value
		if game_env:
			game_env_ready.emit()

signal game_env_ready
signal minigame_complete

const game_paths := {
	"three_card_monte": "res://game/main/mini_games/three_card_monte/tcm_holder.tscn",
	"mastermind": "res://game/main/mini_games/mastermind/mastermind_holder.tscn",
	"memory": "res://game/main/mini_games/memory/memory_game.tscn",
}

const tutorial_paths := {
	"three_card_monte": "res://game/main/mini_games/tutorials/three_card_monte/three_card_monte_tutorial.tscn",
	"mastermind": "res://game/main/mini_games/tutorials/mastermind/mastermind_tutorial.tscn",
	"memory": "res://game/main/mini_games/tutorials/memory/memory_tutorial.tscn",
	
}

func _ready() -> void:
	await game_env_ready

func clear_minigame()->bool:
	for child in get_children():
		child.call_deferred("queue_free")
		await child.tree_exited
	return true
	
func start_mini_game(game_id: int):
	assert(game_id in [0,1,2])
	#game_env.mini_game_mode = true
	game_env.game_mode = game_env.GameMode.MINI_GAME
	await clear_minigame()
	await _adjust_camera("in")
	
	match game_id:
		0: # THREE_CARD_MONTE
			_load_game("three_card_monte")
		1: # MASTERMIND
			_load_game("mastermind")
		2: # MEMORY
			_load_game("memory")

func _load_game(game_string: String):
	assert(
		game_string in game_paths.keys() and 
		game_string in tutorial_paths.keys()
	)
	var tutorial_scene: PackedScene
	var game_scene: PackedScene
	var tutorial_node: Panel	
	var game_node: Panel

	match game_string:
		"three_card_monte":
			tutorial_scene = load(tutorial_paths["three_card_monte"])
			game_scene = load(game_paths["three_card_monte"])
		"mastermind":
			tutorial_scene = load(tutorial_paths["mastermind"])
			game_scene = load(game_paths["mastermind"])
		"memory":
			tutorial_scene = load(tutorial_paths["memory"])
			game_scene = load(game_paths["memory"])
			
	tutorial_node = tutorial_scene.instantiate()
	call_deferred("add_child", tutorial_node)
	await tutorial_node.tree_entered	
	
	assert(tutorial_node.has_signal("tutorial_finished"))
	await tutorial_node.tutorial_finished
	
	tutorial_node.call_deferred("queue_free")
	await tutorial_node.tree_exited
	
	var mc: MainCanvas = SingletonHolder.game_manager.main.main_canvas
	mc.show_layer(mc.hud, true)
	
	game_node = game_scene.instantiate()
	call_deferred("add_child", game_node)
	await game_node.tree_entered
	
	assert(game_node.has_signal("game_complete"))
	await game_node.game_complete
	
	_on_game_complete()

func _on_game_complete():
	await clear_minigame()
	
	var mc: MainCanvas = SingletonHolder.game_manager.main.main_canvas
	mc.show_layer(mc.hud, false)
	
	await _adjust_camera("out")
	#game_env.mini_game_mode = false
	game_env.game_mode = game_env.GameMode.NONE
	minigame_complete.emit()

func _adjust_camera(direction: String)->bool:
	assert(direction in ["in","out"])
	var cammy: GameCamera = game_env.game_camera
	if direction == "in":
		cammy.zoom_in()
		await cammy.zoom_in_complete
		return true
	if direction == "out":
		cammy.zoom_out()
		await cammy.zoom_out_complete
		return true
	return true

func end_mini_game():
	pass
	
