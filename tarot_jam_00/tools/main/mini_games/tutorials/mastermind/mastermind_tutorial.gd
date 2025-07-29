class_name MastermindTutorial
extends Panel

@onready var continue_button: Button = $ContinueButton

@onready var slide_01: Node2D = $Slide01
@onready var slide_02: Node2D = $Slide02
@onready var slide_03: Node2D = $Slide03
@onready var slide_04: Node2D = $Slide04
@onready var slide_05: Node2D = $Slide05
@onready var slide_06: Node2D = $Slide06
@onready var slide_07: Node2D = $Slide07


signal tutorial_finished

const CONTINUE_DELAY := 0.5
const FLASH_DURATION := 0.1

var flash_tween: Tween

var slides := []

var current_slide := -1:
	set(new_value):
		current_slide = new_value
		continue_button.visible = false
		for slide: Node2D in slides:
			slide.visible = false
		(slides[current_slide] as Node2D).visible = true
		await get_tree().create_timer(CONTINUE_DELAY).timeout
		continue_button.visible = true

func _ready() -> void:
	slides = [
		slide_01,
		slide_02,
		slide_03,
		slide_04,
		slide_05,
		slide_06,
		slide_07,
	]
	
	
	current_slide += 1
	
	continue_button.pressed.connect(
		func()->void:
			#                       3
			if current_slide < slides.size()-1:
				current_slide += 1
			else:
				tutorial_finished.emit()
	)
	
	continue_button.visibility_changed.connect(
		func()->void:
			if continue_button.visible:
				continue_button.mouse_filter = Control.MOUSE_FILTER_IGNORE
				await SingletonHolder.tween_service.flash_button(continue_button, FLASH_DURATION)
				continue_button.mouse_filter = Control.MOUSE_FILTER_STOP
	)
	

		
		
