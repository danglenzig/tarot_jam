
extends Control

@onready var button: Button = %Button

func _ready() -> void:
	button.pressed.connect(
		func()->void:
			SingletonHolder.event_bus.hide_about.emit()
	)
