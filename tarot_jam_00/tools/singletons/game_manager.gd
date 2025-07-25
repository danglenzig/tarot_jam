class_name GameManager
extends Node

signal main_added
signal hp_updated(new_hp: float)
const SAVE_PATH = "user://game_data.tres"

var game_data: GameData = null

var hp := 1000.0:
	set(new_value):
		hp = new_value
		hp_updated.emit(hp)

var main: Main = null:
	set(new_value):
		main = new_value
		if main: main_added.emit()
		
var damage_per_hit := {
	# these values will need tuning & balancing
	"mastermind": 		20.0,
	"memory": 			50.0,
	"three_card_monte": 100.0
}
const MAX_HP := 1000.0

func _ready() -> void:
	start_new_game()

func _recalculate_mannequinity(_hp):
	pass # TODO
	
func _on_fully_mannequin():
	pass # TODO

func take_hit(mini_game_name: String):
	#if not game_data: return
	assert(mini_game_name in damage_per_hit.keys())
	var damage: float = damage_per_hit[mini_game_name]
	if hp - damage > 0:
		hp -= damage
		_recalculate_mannequinity(hp)
	else:
		_on_fully_mannequin() # master lose condition
		
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
		
