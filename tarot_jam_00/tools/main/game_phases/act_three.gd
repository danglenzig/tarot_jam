class_name ActThree
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
	#print_debug("BEGIN ACT THREE")
	
	var mc: MainCanvas = main.main_canvas
	var maddie_convo_01: Conversation = maddie_convo_01_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo_01)
	
func _on_show_memory_label():
	var mc = main.main_canvas
	var ml: MemoryLabel = mc.memory
	mc.show_layer(ml, true)
	await ml.activate()
	
func _on_end_of_act_three():
	active = false
	main.game_three_complete.emit()
	
func _on_start_memory():
	var mc = main.main_canvas
	var ml: MemoryLabel = mc.memory
	mc.show_layer(ml, false)
	
	mg_manager.start_mini_game(mg_manager.MiniGames.MEMORY)
	
	await mg_manager.minigame_complete
	
	var maddie_convo_02: Conversation = maddie_convo_02_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo_02)
	
	
func _on_show_audience():
	var bg: BackgroundSprite = main.game_environment.background_sprite
	bg.texture = load(
		"res://imported_assets/audience/Audience 4.png"
	)
func _on_show_bg():
	var bg: BackgroundSprite = main.game_environment.background_sprite
	bg.texture = load(
		"res://imported_assets/01.jpg"
	)

func _on_dialogue_data_signal_rxd(data: String):
	if not active: return
	var sm: SoundManager = main.sound_manager
	match data:
		"end_of_act_three":
			_on_end_of_act_three()
		"start_memory":
			_on_start_memory()
		"show_memory_label":
			sm.play_audience_reaction(sm.APPLAUSE_01)
			_on_show_memory_label()
			
		"show_audience":
			_on_show_audience()
		
		"show_bg":
			_on_show_bg()
		
		"laugh":
			sm.play_audience_reaction(sm.LAUGH)
			
		
		_:
			pass
