class_name GameManager
extends Node

signal main_added

var game_data: GameData = null

var main: Main = null:
	set(new_value):
		main = new_value
		if main: main_added.emit()
		
const SAVE_PATH = "user://game_data.tres"

func _load_saved_data()->void:
	if ResourceLoader.exists(SAVE_PATH):
	#if FileAccess.file_exists(SAVE_PATH):
		game_data = ResourceLoader.load(SAVE_PATH) as GameData
		if game_data:
			game_data.resource_local_to_scene = true
			
		#print_debug(game_data.objective_tracker_data)	
		
	else:
		print_debug("No saved data found")
		start_new_game()

func start_new_game()->void:
	_clear_saved_data()
	game_data = GameData.new()

func _clear_saved_data()->void:
	if not ResourceLoader.exists(SAVE_PATH):
	#if not FileAccess.file_exists(SAVE_PATH):
		return
	DirAccess.remove_absolute(SAVE_PATH)
