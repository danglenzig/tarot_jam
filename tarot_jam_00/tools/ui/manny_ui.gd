class_name MannyUi
extends Node2D

@onready var gm: GameManager = SingletonHolder.game_manager
@onready var manny_sprite: Sprite2D = $MannySprite
@onready var bg_rect: ColorRect = $BGRect

var pulse_tween: Tween = null

const _0_125 = preload("res://imported_assets/mannequin_ui/0_125.png")
const _0_125_ALT = preload("res://imported_assets/mannequin_ui/0_125_alt.png")
const _125_250 = preload("res://imported_assets/mannequin_ui/125_250.png")
const _250_375 = preload("res://imported_assets/mannequin_ui/250_375.png")
const _375_500 = preload("res://imported_assets/mannequin_ui/375_500.png")
const _500_625 = preload("res://imported_assets/mannequin_ui/500_625.png")
const _625_750 = preload("res://imported_assets/mannequin_ui/625_750.png")
const _750_875 = preload("res://imported_assets/mannequin_ui/750_875.png")
const _875_1000 = preload("res://imported_assets/mannequin_ui/875_1000.png")

const PULSE_DURATION := 0.25

var legs_view := 0

func _ready() -> void:
	visible = false
	await gm.main_added
	
	var minigame_manager: MiniGameManager = (
		SingletonHolder.game_manager.main.game_environment.mini_game_manager
	)
	var cammy: GameCamera = (
		SingletonHolder.game_manager.main.game_environment.game_camera
	)
	minigame_manager.started_mini_game.connect(
		func(game_idx)->void:
			if game_idx == minigame_manager.MiniGames.THREE_CARD_MONTE:
				visible = true
	)
	cammy.zoom_out_complete.connect(start_highlight_pulse)
	
	gm.hp_updated.connect(_on_hp_updated)
	
func _on_hp_updated(hp):
	
	
	var mannequenity = SingletonHolder.game_manager.MAX_HP - hp
	
	mannequenity /= 1000
	
	if mannequenity <= 0.125:
		manny_sprite.texture = _0_125
		legs_view = 0
	elif mannequenity <= .250:
		manny_sprite.texture = _125_250
		legs_view = 1
	elif mannequenity <= .375:
		manny_sprite.texture = _250_375
		legs_view = 2
	elif mannequenity <= .500:
		manny_sprite.texture = _375_500
		legs_view = 3
	elif mannequenity <= .625:
		manny_sprite.texture = _500_625
		legs_view = 4
	elif mannequenity <= .750:
		manny_sprite.texture = _625_750
	elif mannequenity <= .875:
		manny_sprite.texture = _750_875
	else:
		manny_sprite.texture = _875_1000
		
		
func start_highlight_pulse():
	
	if not visible: return
	
	if pulse_tween:
		pulse_tween.kill()
		pulse_tween = null
	
	bg_rect.color.r = 0.0
	
	for i in range(3):
		pulse_tween = create_tween()
		pulse_tween.tween_property(
			bg_rect,
			"color:r",
			1.0,
			PULSE_DURATION
		)
		await pulse_tween.finished
		pulse_tween = create_tween()
		
		pulse_tween.tween_property(
			bg_rect,
			"color:r",
			0.0,
			PULSE_DURATION
		)
		await pulse_tween.finished
		pulse_tween.kill()
		pulse_tween = null
		
		
