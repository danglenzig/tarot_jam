class_name AdvertOnePhase
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
	print("PLAY ADVERT ONE")
	
	assert(ad_manager)
	
	ad_manager.start_advert(ad_manager.Adverts.ADVERT_ONE)
	
	await ad_manager.advert_complete
	active = false
	main.advert_one_complete.emit()
	
	

# func _on_dialogue_data_signal_rxd(data: String):
#	
#	match data:
#		_:
#			pass
