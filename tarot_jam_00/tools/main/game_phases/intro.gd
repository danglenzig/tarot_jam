class_name Intro
extends Node

@export var intro_monologue_scene: PackedScene
@export var this_will_do_scene: PackedScene
@export var maddie_intro_convo_scene_01: PackedScene


signal main_ready

var main: Main = null:
	set(new_value):
		main = new_value
		if main:
			main_ready.emit()

func _ready() -> void:
	await main_ready
	#tv_turned_on.connect(_on_tv_turned_on)
	#this_will_do_pressed.connect(_on_this_will_do_pressed)
	
	#main.main_canvas.dialogue.dialogue_choice_taken.connect(_on_dialogue_choice_taken)
	#main.main_canvas.dialogue.line_finished_signal.connect(_on_dialogue_line_finished_signal)
	main.main_canvas.dialogue.dialogue_data_signal.connect(_on_dialogue_data_signal_rxd)

func play():
	var mc: MainCanvas = main.main_canvas
	var ge: GameEnvironment = main.game_environment
	
	mc.show_layer(mc.transition_screen, true)
	var ts: TransitionScreen = mc.transition_screen
	ts.fade_in()
	await ts.fade_in_complete
	
	mc.show_layer(mc.start_menu, false)
	
	var background: BackgroundSprite = ge.background_sprite
	background.texture = load("res://imported_assets/black_screenjp.jpg")
	await get_tree().create_timer(1.0).timeout
	
	ts.fade_out()
	
	await ts.fade_out_complete
	mc.show_layer(mc.transition_screen, false)
	
	var dialogue: Dialogue = mc.dialogue
	var intro_monologue := intro_monologue_scene.instantiate() as Conversation
	dialogue._start_dialogue(intro_monologue)
	
func _on_tv_turned_on():
	print_debug("Player turned on the TV")
	
	var background: BackgroundSprite = main.game_environment.background_sprite
	background.texture = load("res://imported_assets/01.jpg")
	background.game_show_title_label.visible = true
	
	await get_tree().create_timer(1.0).timeout
	
	var mc: MainCanvas = main.main_canvas
	var dialogue: Dialogue = mc.dialogue
	
	var this_will_do_monologe: Conversation = this_will_do_scene.instantiate()
	dialogue._start_dialogue(this_will_do_monologe)
	
	
func _on_this_will_do_pressed():
	#print_debug("TODO: Maddie appears and the game show starts.\nBrad is taking a break now.")
	var bg: BackgroundSprite = main.game_environment.background_sprite
	
	await get_tree().create_timer(1.75).timeout
	
	bg.game_show_title_label.visible = false
	
	var dialoge: Dialogue = main.main_canvas.dialogue
	var maddie_convo: Conversation = maddie_intro_convo_scene_01.instantiate()
	dialoge._start_dialogue(maddie_convo)
	
	
func _on_dialogue_data_signal_rxd(data: String):
	var bg: BackgroundSprite = main.game_environment.background_sprite
	match data:
		"tv_turned_on":
			_on_tv_turned_on()
		"this_will_do":
			_on_this_will_do_pressed()
			
		"theme_alert":
			await _on_theme_alert()
		"end_of_intro":
			_on_end_of_intro()
			
		"show_contestants":
			
			bg.texture = load("res://imported_assets/contestants.png")
			
		"studio_cam_1":
			bg.texture = load("res://imported_assets/01.jpg")
func _on_dialogue_choice_taken(data: String):
	match data:
		"tv_turned_on":
			_on_tv_turned_on()
		"this_will_do":
			_on_this_will_do_pressed()
		_:
			return
			
func _on_dialogue_line_finished_signal(data: String):
	var bg: BackgroundSprite = main.game_environment.background_sprite
	match data:
		"theme_alert":
			await _on_theme_alert()
		"end_of_intro":
			_on_end_of_intro()
			
		"show_contestants":
			
			bg.texture = load("res://imported_assets/contestants.png")
			
		"studio_cam_1":
			bg.texture = load("res://imported_assets/01.jpg")
			
		_:
			return

func _on_end_of_intro():
	
	await get_tree().create_timer(1.5).timeout
	
	print_debug("FOOOOOOOOO BAAAAAAAAR")
	
	main.intro_complete.emit()

func _on_theme_alert()->bool:
	var mc: MainCanvas = main.main_canvas
	var ta: ThemeAlert = mc.theme_alert
	mc.show_layer(mc.theme_alert, true)
	await ta.theme_alret_complete
	return true
