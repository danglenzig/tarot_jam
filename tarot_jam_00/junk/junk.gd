extends Node2D

func _ready() -> void:
	var my_uuid := SingletonHolder.misc_tools.get_uuid()
	print(my_uuid)
	
	SingletonHolder.event_bus.something_happened.emit()
	
	SingletonHolder.event_bus.something_happened.connect(
		func()->void:
			pass
			#do_stuff()
	)
