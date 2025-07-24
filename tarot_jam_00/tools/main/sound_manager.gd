class_name SoundManager
extends Node


@onready var master_bus_idx = AudioServer.get_bus_index("Master")
@onready var adverts_bus_idx = AudioServer.get_bus_index("Adverts")
@onready var sfx_bus_idx = AudioServer.get_bus_index("SFX")
@onready var music_bus_idx = AudioServer.get_bus_index("Music")
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var one_shot_sfx: AudioStreamPlayer = $OneShotSFX
@onready var sine_player: AudioStreamPlayer = $SinePlayer


var music_volume_tween: Tween
var sine_pitch_tween: Tween


var master_volume: float:
	set(new_value):
		master_volume = new_value
		AudioServer.set_bus_volume_db(master_bus_idx, master_volume)

var adverts_volume: float:
	set(new_value):
		adverts_volume = new_value
		AudioServer.set_bus_volume_db(adverts_bus_idx, adverts_volume)
		
var sfx_volume: float:
	set(new_value):
		sfx_volume = new_value
		AudioServer.set_bus_volume_db(sfx_bus_idx, sfx_volume)
		
var music_volume: float:
	set(new_value):
		music_volume = new_value
		AudioServer.set_bus_volume_db(music_bus_idx, music_volume)



const MAIN_MUSIC = preload("res://imported_assets/Sound/jazz_in_paris.ogg")
const BELL = preload("res://imported_assets/Sound/GUI_Accept_5.wav")

const DA_DING = preload("res://imported_assets/Sound/da_ding.ogg")

const BUZZ_1 = preload("res://imported_assets/Sound/GUI_Cancel_6.wav")
const BUZZ_2 = preload("res://imported_assets/Sound/GUI_Cancel_2.wav")

const DIALOGUE_ADVANCE = preload("res://imported_assets/Sound/GUI_Accept_7.wav")
const UI_BUTTON = preload("res://imported_assets/Sound/GUI_Cancel_7.wav")

const MUSIC_MAX_VOLUME := 0.0
const MUSIC_MIN_VOLUME := -30.0
const SINE_MAX_PITCH := 1.5
const SINE_MIN_PITCH := 0.25


func _ready() -> void:	
	music_volume = MUSIC_MAX_VOLUME
	
func _play_main_music(play_music := true):
	if play_music:
		if music_player.playing: return
		music_player.stream = MAIN_MUSIC
		music_player.play()
	else:
		if not music_player.playing: return
		music_player.stop()
		music_player.stream = null
		
func tween_music_down(duration: float):
	duration = clamp(duration, 0.1, 5.0)
	if music_volume_tween:
		music_volume_tween.kill()
		music_volume_tween = null
	music_volume_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	music_volume_tween.tween_property(
		self,
		"music_volume",
		MUSIC_MIN_VOLUME,
		duration
	)
	music_volume_tween.finished.connect(
		func()->void:
			music_volume_tween.kill()
			music_volume_tween = null
	)
func tween_music_up(duration: float):
	duration = clamp(duration, 0.1, 2.0)
	if music_volume_tween:
		music_volume_tween.kill()
		music_volume_tween = null
	music_volume_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	music_volume_tween.tween_property(
		self,
		"music_volume",
		MUSIC_MAX_VOLUME,
		duration
	)
	music_volume_tween.finished.connect(
		func()->void:
			music_volume_tween.kill()
			music_volume_tween = null
	)

func play_bell():
	if one_shot_sfx.playing:
		one_shot_sfx.stop()
	one_shot_sfx.stream = BELL
	one_shot_sfx.play()
	
func play_buzz(buzz_sound: Resource):
	if one_shot_sfx.playing:
		one_shot_sfx.stop()
	one_shot_sfx.stream = buzz_sound
	one_shot_sfx.play()
	
func play_da_ding():
	if one_shot_sfx.playing:
		one_shot_sfx.stop()
	one_shot_sfx.stream = DA_DING
	one_shot_sfx.play()
	
func play_one_shot_sfx(sfx: Resource):
	if one_shot_sfx.playing:
		one_shot_sfx.stop()
	one_shot_sfx.stream = sfx
	one_shot_sfx.play()
	
func tween_up_sine_tone(duration: float):
	duration = clamp(duration, 0.1, 5.0)
	sine_player.pitch_scale = SINE_MIN_PITCH
	if sine_pitch_tween:
		sine_pitch_tween.kill()
		sine_pitch_tween = null
	sine_pitch_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD)
	sine_player.play()
	sine_pitch_tween.tween_property(
		sine_player,
		"pitch_scale",
		SINE_MAX_PITCH,
		duration
	)
	sine_pitch_tween.finished.connect(
		func()->void:
			sine_pitch_tween.kill()
			sine_pitch_tween = null
			sine_player.stop()
	)
	
	
		
