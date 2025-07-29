class_name MemoryTutorial
extends Panel


@onready var continue_button: Button = $ContinueButton

signal tutorial_finished

const CONTINUE_DELAY := 0.5
const FLASH_DURATION := 0.1

var flash_button_tween: Tween

func _ready() -> void:
	continue_button.pressed.connect(
		func()->void:
			tutorial_finished.emit()
	)
	
	continue_button.visibility_changed.connect(
		func()->void:
			if continue_button.visible:
				continue_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
				await SingletonHolder.tween_service.flash_button(continue_button, FLASH_DURATION)
				continue_button.mouse_filter = Control.MOUSE_FILTER_STOP
	)
