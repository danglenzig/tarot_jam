class_name Main
extends Node2D

@onready var main_canvas: MainCanvas = $MainCanvas
@onready var post_process: PostProcess = %PostProcess

@export var test_convo_scene: PackedScene


func _ready() -> void:
	SingletonHolder.game_manager.main = self
	
	
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
	
	
	
