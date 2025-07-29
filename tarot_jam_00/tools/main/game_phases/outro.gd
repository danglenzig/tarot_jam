class_name Outro
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
	print("PLAY OUTRO")
	
	var hp: float = SingletonHolder.game_manager.hp
	
	if hp <= 125:
		_play_outro_one()
		return
	else:
		_play_outro_two()
		#_play_outro_two()
		return
	
	var mc: MainCanvas = main.main_canvas
	var convo_01: Conversation = maddie_convo_01_scene.instantiate()
	mc.dialogue._start_dialogue(convo_01)
	
	

func _play_outro_one():
	var mc: MainCanvas = main.main_canvas
	var convo_01: Conversation = maddie_convo_01_scene.instantiate()
	mc.dialogue._start_dialogue(convo_01)

func _play_outro_two():
	var mc: MainCanvas = main.main_canvas
	var convo_02: Conversation = maddie_convo_02_scene.instantiate()
	mc.dialogue._start_dialogue(convo_02)

	
func _on_outro_finished():
	
	# temp
	
	print("BYE!")
	
	var bg: BackgroundSprite = main.game_environment.background_sprite
	bg.texture = load(
		"res://imported_assets/01.jpg"
	)
	
	await get_tree().create_timer(1.0).timeout
	
	main.outro_complete.emit()
	
func _on_dialogue_data_signal_rxd(data: String):
	if not active: return
	match data:
		
		"outro_finished":
			_on_outro_finished()
		"show _audience_1":
			var sm: SoundManager = main.sound_manager
			sm.play_audience_reaction(sm.APPLAUSE_01)
			var bg: BackgroundSprite = main.game_environment.background_sprite
			bg.texture = load(
				"res://imported_assets/audience/Audience 5.png"
			)
		_:
			pass
