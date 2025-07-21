class_name MainCanvas
extends CanvasLayer

@onready var hud: Hud = %Hud
@onready var start_menu: StartMenu = %StartMenu
@onready var transition_screen: Control = %TransitionScreen
@onready var logo_splash: LogoSplash = %LogoSplash


func show_layer(the_layer: Control, show_value: bool, hide_others: bool = false):
	var layers := get_children()
	if hide_others:
		for child_layer: Control in layers:
			child_layer.visible = false
	assert(the_layer in layers)
	the_layer.visible = show_value
