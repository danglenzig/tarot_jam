class_name Main
extends Node2D

@onready var main_canvas: MainCanvas = $MainCanvas
@onready var post_process: PostProcess = %PostProcess


func _ready() -> void:
	SingletonHolder.game_manager.main = self
	
	
