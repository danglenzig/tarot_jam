class_name ActOne
extends Node

@export var maddie_convo_01_scene: PackedScene
@export var maddie_convo_02_scene: PackedScene

var main: Main = null:
	set(new_value):
		main = new_value
		if main:
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
	print_debug("Act one begins")
	var mc: MainCanvas = main.main_canvas
	
	var gk_ui: GeneralKnowledge = mc.general_knowledge
	mc.show_layer(mc.general_knowledge,true)
	await gk_ui.activate()
	
	await get_tree().create_timer(1.5).timeout
	
	var maddie_convo_01: Conversation = maddie_convo_01_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo_01)
	
	

func _on_end_of_act_one():
	
	
	active = false
	main.game_one_complete.emit()
	
func _on_show_red_x():
	var gk_ui: GeneralKnowledge = main.main_canvas.general_knowledge
	gk_ui.show_red_X()

func _on_show_tcm():
	var gk_ui: GeneralKnowledge = main.main_canvas.general_knowledge
	await gk_ui.show_tcm()
	
func _on_start_tcm():
	var mc := main.main_canvas
	mc.show_layer(mc.general_knowledge, false)
	#print_debug("start_three_card_monte")
	
	mg_manager.start_mini_game(mg_manager.MiniGames.THREE_CARD_MONTE)
	
	await mg_manager.minigame_complete
	
	var maddie_convo: Conversation = maddie_convo_02_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo)
	
	

func _on_dialogue_data_signal_rxd(data: String):
	if not active: return
	match data:
		"show_red_x":
			_on_show_red_x()
			
		"show_tcm":
			_on_show_tcm()
			
		"start_three_card_monte":
			_on_start_tcm()
			
		"show_commercial":
			
			_on_end_of_act_one()
		
		_:
			pass
