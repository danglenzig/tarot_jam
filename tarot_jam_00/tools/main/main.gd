class_name Main
extends Node2D

@onready var main_canvas: MainCanvas = $MainCanvas
@onready var post_process: PostProcess = %PostProcess
@onready var game_environment: GameEnvironment = %GameEnvironment

@export var test_convo_scene: PackedScene


func _ready() -> void:
	SingletonHolder.game_manager.main = self
	
	
	
	
	%BradsTestButton.pressed.connect(_on_brads_test_button_pressed)
	
func _on_brads_test_button_pressed():
	%BradsTestButton.visible = false
	game_environment.game_camera.zoom_in()
	SingletonHolder.event_bus.start_minigame.emit()
	
	
	"""
	# camera zoom test
	#await get_tree().create_timer(2.0).timeout
	game_environment.game_camera.zoom_in()
	await game_environment.game_camera.zoom_in_complete
	print_debug("FOO")
	
	await get_tree().create_timer(2.0).timeout
	game_environment.game_camera.zoom_out()
	await game_environment.game_camera.zoom_out_complete
	print_debug("BAR")
	
	%BradsTestButton.visible = true
	
	
	# dialogue test
	
	var current_convo_uuid := ""
	
	await get_tree().create_timer(2.0).timeout
	var test_convo = test_convo_scene.instantiate() as Conversation
	test_convo.conversation_uuid = SingletonHolder.misc_tools.get_uuid()
	current_convo_uuid = test_convo.conversation_uuid
	SingletonHolder.event_bus.start_dialogue_signal.emit(test_convo, 0)
	
	SingletonHolder.event_bus.dialogue_ended.connect(
		func(uuid: String)->void:
			if uuid == current_convo_uuid:
				current_convo_uuid = ""
				test_convo.queue_free()
	)
	
	
	
	"""
