class_name LogoSplash
extends Control

@onready var logo_sprite: Sprite2D = $Sprite2D

signal main_ready

var tween: Tween = null


var sm: SoundManager
var main: Main = null:
	set(new_value):
		main = new_value
		if main:
			main_ready.emit()

var logo_scale := 1.0:
	set(new_value):
		logo_scale = new_value
		logo_sprite.scale = Vector2(logo_scale,logo_scale)
			

func _ready() -> void:
	await main_ready
	sm = SingletonHolder.game_manager.main.sound_manager
	logo_sprite.visible = false

func activate()->bool:
	logo_scale = 0.1
	if tween:
		tween.kill()
		tween = null
	tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	logo_sprite.visible = true
	tween.tween_property(
		self,
		"logo_scale",
		1.0,
		.5
	)
	await tween.finished
	
	sm.play_one_shot_sfx(sm.THUD)
	
	tween.kill()
	tween = null
	
	await get_tree().create_timer(3.5).timeout
	
	return true
