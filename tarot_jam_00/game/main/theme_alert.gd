class_name ThemeAlert
extends Control
@onready var label: Label = $Panel/Label
@onready var panel: Panel = $Panel

signal theme_alret_complete

func _ready()->void:
	visibility_changed.connect(_on_visibility_changed)
	
func _on_visibility_changed():
	if not visible: return
	for i in range(3):
		if panel.visible == true:
			await get_tree().create_timer(0.5).timeout
			panel.visible = false
		else:
			await get_tree().create_timer(0.2).timeout
			panel.visible = true
	theme_alret_complete.emit()
		
