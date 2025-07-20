class_name Main
extends Node2D

func _ready() -> void:
	SingletonHolder.game_manager.main = self
