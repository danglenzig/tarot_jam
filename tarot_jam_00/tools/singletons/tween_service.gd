class_name TweenService
extends Node


var flash_button_tween: Tween

func flash_button(button: Button, duration: float)->bool:
	
	duration = max(duration, 0.05)
	
	if flash_button_tween:
		flash_button_tween.kill()
		flash_button_tween = null
		
	button.self_modulate = Color(1.0,1.0,1.0,1.0)
	
	
	for i in range(3):
		flash_button_tween = create_tween()
		flash_button_tween.tween_property(
			button,
			"self_modulate:b",
			0.0,
			duration,
		)
		await flash_button_tween.finished
		flash_button_tween.kill()
		flash_button_tween = null
		flash_button_tween = create_tween()
		flash_button_tween.tween_property(
			button,
			"self_modulate:b",
			1.0,
			duration,
		)
		await flash_button_tween.finished
		flash_button_tween.kill()
		flash_button_tween = null
		
	return true
