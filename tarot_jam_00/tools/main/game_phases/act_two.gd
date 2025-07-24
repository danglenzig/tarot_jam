class_name ActTwo
extends Node

@export var maddie_convo_01_scene: PackedScene
@export var maddie_convo_02_scene: PackedScene

var main: Main = null:
	set(new_value):
		main = new_value
		main_ready.emit()

var active := false
var mg_manager: MiniGameManager = null

signal main_ready

func _ready() -> void:
	await main_ready
	main.main_canvas.dialogue.dialogue_data_signal.connect(_on_dialogue_data_signal_rxd)
	mg_manager = main.game_environment.mini_game_manager
	
	
	
	
func play():
	active = true
	print_debug("BEGIN ACT TWO")
	
	var mc: MainCanvas = main.main_canvas
	var maddie_convo_01: Conversation = maddie_convo_01_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo_01)

func _on_show_mastermind_label():
	var mc: MainCanvas = main.main_canvas
	
	var mm: MastermindLabel = mc.master_mind
	mc.show_layer(mm, true)
	await mm.activate()

func _on_end_of_act_two():
	active = false
	main.game_two_complete.emit()
	
func _on_start_mastermind():
	var mc: MainCanvas = main.main_canvas
	
	var mm: MastermindLabel = mc.master_mind
	mc.show_layer(mm, false)
	
	mg_manager.start_mini_game(mg_manager.MiniGames.MASTERMIND)
	
	
	
	await mg_manager.minigame_complete
	
	var maddie_convo_02: Conversation = maddie_convo_02_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo_02)
	
func _on_dialogue_data_signal_rxd(data: String):
	if not active: return
	match data:
		
		"end_of_act_two":
			_on_end_of_act_two()
			
		"start_mastermind":
			_on_start_mastermind()
			
		"show_mastermind_label":
			_on_show_mastermind_label()
		
		_:
			pass
