class_name StartMenu
extends Control

@onready var start_menu_buttons_vbox: VBoxContainer = %StartMenuButtonsVbox
@onready var start_button: Button = %StartButton
@onready var continue_button: Button = %ContinueButton
@onready var about_button: Button = %AboutButton
@onready var quit_button: Button = %QuitButton
@onready var game_title_label: Label = %GameTitleLabel


func _ready() -> void:
	var buttons := start_menu_buttons_vbox.get_children()
	for button: Button in buttons:
		button.pressed.connect(_on_start_menu_button_pressed.bind(button))

func _on_start_menu_button_pressed(button: Button):
	match button:
		start_button:
			pass
		continue_button:
			pass
		about_button:
			pass
		quit_button:
			pass
