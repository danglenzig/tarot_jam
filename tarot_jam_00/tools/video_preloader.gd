class_name VideoPreloader
extends Node

func _ready() -> void:
	pass
	#preload("res://imported_assets/video/test_video.ogg")
	
func preload_videos():
	preload("res://imported_assets/video/test_video.ogg")
	return true
