class_name ThreeCardMonteTutorial
extends Panel

@onready var slide_01: Node2D = $Slide01
@onready var slide_02: Node2D = $Slide02
@onready var slide_03: Node2D = $Slide03
@onready var slide_04: Node2D = $Slide04


@onready var continue_button: Button = $ContinueButton


var slides := []

var current_slide := -1:
	set(new_value):
		current_slide = new_value
		continue_button.visible = false
		for slide: Node2D in slides:
			slide.visible = false
		(slides[current_slide] as Node2D).visible = true
		await get_tree().create_timer(2.0).timeout
		continue_button.visible = true


signal tutorial_finished

func _ready() -> void:
	slides = [slide_01, slide_02, slide_03, slide_04]
	current_slide += 1
	
	
	continue_button.pressed.connect(
		func()->void:
			#                       3
			if current_slide < slides.size()-1:
				current_slide += 1
			else:
				tutorial_finished.emit()
			
	)
