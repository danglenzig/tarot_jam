class_name AdvertTwoPhase
extends Node

var main: Main = null:
	set(new_value):
		main = new_value
		if main:
			main_ready.emit()

var active = false
var ad_manager: AdvertManager = null

signal main_ready

func _ready() -> void:
	await main_ready
	
	#main.main_canvas.dialogue.dialogue_data_signal.connect(_on_dialogue_data_signal_rxd)
	ad_manager = main.game_environment.advert_manager
	
func play():
	active = true
	print("PLAY ADVERT TWO")
	
	assert(ad_manager)
	
	ad_manager.start_advert(ad_manager.Adverts.ADVERT_TWO)
	
	await ad_manager.advert_complete
	active = false
	main.advert_two_complete.emit()
