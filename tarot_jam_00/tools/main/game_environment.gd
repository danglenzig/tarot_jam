class_name GameEnvironment
extends Node2D

@onready var game_camera: GameCamera = %GameCamera
@onready var background_sprite: BackgroundSprite = %BackgroundSprite
@onready var left_speaker_sprite: SpeakerSprite = %LeftSpeakerSprite
@onready var right_speaker_sprite: SpeakerSprite = %RightSpeakerSprite
@onready var tv_frame_sprite: Sprite2D = %TVFrameSprite
@onready var mini_game_manager: Node2D = %MiniGameManager

@onready var event_bus: EventBus = SingletonHolder.event_bus

func _ready() -> void:
	left_speaker_sprite.texture = null
	right_speaker_sprite.texture = null
	event_bus.dialogue_line_updated.connect(_on_dialogue_line_updated)
	event_bus.dialogue_ended.connect(_on_dialogue_ended)

func _on_dialogue_ended(_uuid):
	left_speaker_sprite.texture = null
	right_speaker_sprite.texture = null

func _on_dialogue_line_updated(speaker_sprite_side: int ,speaker_texture: Texture):
	if speaker_texture:
		match speaker_sprite_side:
			DialogueLine.PortaitSide.LEFT: # 0
				left_speaker_sprite.texture = speaker_texture
				right_speaker_sprite.texture = null
			DialogueLine.PortaitSide.RIGHT: # 1
				left_speaker_sprite.texture = null
				right_speaker_sprite.texture = speaker_texture
				
