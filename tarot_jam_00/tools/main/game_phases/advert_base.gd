class_name Advert
extends Panel

@export var advert_name := ""
@export var dev_button: Button
@export var dev_mode := false
@export var video: VideoStreamPlayer


signal advert_finished(ad_name: String)

func _ready() -> void:
	
	dev_button.visible = dev_mode
	if dev_button.visible:
		dev_button.pressed.connect(
			func()->void:
				advert_finished.emit()
		)
		
	video.finished.connect(
		func()->void:
			advert_finished.emit()
	)
	
	extra_ready_stuff()
	
func play_video():
	video.play()

#### overridden functions ####
func extra_ready_stuff():
	pass
