class_name Hud
extends Control

@onready var progress_bar: ProgressBar = $HudPanel/ProgressBar

func _ready() -> void:
	progress_bar.value = SingletonHolder.game_manager.MAX_HP
	SingletonHolder.game_manager.hp_updated.connect(_on_hp_updated)
	
func _on_hp_updated(hp):
	progress_bar.value = hp
