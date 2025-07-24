class_name MastermindTutorial
extends Panel

@onready var continue_button: Button = $ContinueButton


signal tutorial_finished

func _ready() -> void:
	continue_button.pressed.connect(
		func()->void:
			tutorial_finished.emit()
	)
