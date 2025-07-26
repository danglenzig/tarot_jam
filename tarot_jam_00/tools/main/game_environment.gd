class_name GameEnvironment
extends Node2D

enum GameMode {NONE, MINI_GAME, ADVERT}

var game_mode: GameMode = GameMode.NONE

@onready var game_camera: GameCamera = %GameCamera
@onready var background_sprite: BackgroundSprite = %BackgroundSprite
@onready var left_speaker_sprite: SpeakerSprite = %LeftSpeakerSprite
@onready var right_speaker_sprite: SpeakerSprite = %RightSpeakerSprite
@onready var tv_frame_sprite: Sprite2D = %TVFrameSprite
@onready var mini_game_manager: MiniGameManager = %MiniGameManager
@onready var advert_manager: AdvertManager = %AdvertManager
@onready var manny_ui: MannyUi = %MannyUI


@onready var event_bus: EventBus = SingletonHolder.event_bus

# var mini_game_mode := false


func _ready() -> void:
	left_speaker_sprite.texture = null
	right_speaker_sprite.texture = null
	event_bus.dialogue_line_updated.connect(_on_dialogue_line_updated)
	event_bus.dialogue_ended.connect(_on_dialogue_ended)
	
	mini_game_manager.game_env = self
	advert_manager.game_env = self
	

func _on_dialogue_ended(_uuid):
	
	#if mini_game_mode: return
	#if game_mode != GameMode.NONE: return
	if game_mode == GameMode.MINI_GAME: return # do we need this?
	
	left_speaker_sprite.texture = null
	right_speaker_sprite.texture = null

func _on_dialogue_line_updated(speaker_sprite_side: int ,speaker_texture: Texture):
	
	#if mini_game_mode: return
	if game_mode != GameMode.NONE: return
	
	if speaker_texture:
		match speaker_sprite_side:
			DialogueLine.PortaitSide.LEFT: # 0
				left_speaker_sprite.texture = speaker_texture
				right_speaker_sprite.texture = null
			DialogueLine.PortaitSide.RIGHT: # 1
				left_speaker_sprite.texture = null
				right_speaker_sprite.texture = speaker_texture
	else:
		left_speaker_sprite.texture = null
		right_speaker_sprite.texture = null
				
