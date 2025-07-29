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
	#print_debug("BEGIN ACT TWO")
	
	var mc: MainCanvas = main.main_canvas
	var maddie_convo_01: Conversation = maddie_convo_01_scene.instantiate()
	mc.dialogue._start_dialogue(maddie_convo_01)

func _on_show_mastermind_label():
	var mc: MainCanvas = main.main_canvas
	var mm: MastermindLabel = mc.master_mind
	var sm: SoundManager = main.sound_manager
	mc.show_layer(mm, true)
	await mm.activate()
	sm.play_audience_reaction(sm.APPLAUSE_01)
	

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
	
func _on_show_legs():
	var lv: LegsView = main.game_environment.legs_view
	var sm: SoundManager = main.sound_manager
	sm.play_audience_reaction(sm.LAUGH)
	
	var manny: MannyUi = main.game_environment.tv_frame_sprite.get_node("MannyUI")
	lv.show_legs(manny.legs_view)
	
	
	
func _on_dialogue_data_signal_rxd(data: String):
	if not active: return
	match data:
		
		"end_of_act_two":
			var bg: BackgroundSprite = main.game_environment.background_sprite
			bg.texture = load(
				"res://imported_assets/01.jpg"
			)
			_on_end_of_act_two()
			
		"start_mastermind":
			_on_start_mastermind()
			
		"show_legs":
			_on_show_legs()
			
		"show_mastermind_label":
			_on_show_mastermind_label()
			
		"advert":
			var lv: LegsView = main.game_environment.legs_view
			var bg: BackgroundSprite = main.game_environment.background_sprite
			bg.texture = load(
				"res://imported_assets/audience/Audience 3.png"
				#"res://imported_assets/Audience5.png"
			)
			lv.visible = false
			
		"show_audience_2":
			var bg: BackgroundSprite = main.game_environment.background_sprite
			bg.texture = load(
				"res://imported_assets/audience/Audience 3.png"
			)
			
		"show_bg":
			var bg: BackgroundSprite = main.game_environment.background_sprite
			bg.texture = load(
				"res://imported_assets/01.jpg"
			)
			
		"cheer":
			var sm: SoundManager = main.sound_manager
			sm.play_audience_reaction(sm.APPLAUSE_01)
		
		_:
			pass
