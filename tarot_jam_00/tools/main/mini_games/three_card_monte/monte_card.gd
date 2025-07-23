class_name MonteCard
extends Node2D

@onready var select_rect: SelectRect = $SelectRect
@onready var card_uuid: String = SingletonHolder.misc_tools.get_uuid()

@onready var sprite_2d: Sprite2D =$CardSprite


var value := ""
var game_controller: ThreeCardMonte = null:
	set(new_value):
		game_controller = new_value
		if game_controller:
			controller_ready.emit()
			
var select_enabled := true:
	set(new_value):
		select_enabled = new_value
		if select_enabled:
			select_rect.mouse_filter = Control.MOUSE_FILTER_STOP
		else:
			select_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
			if game_controller.curently_active_card_uuid == card_uuid:
				game_controller.curently_active_card_uuid = ""

var face_texture_path: String = ""

var _shader_mat: ShaderMaterial = null
var face_up := false:
	set(new_value):
		face_up = new_value
		if face_up:
			sprite_2d.texture = load(face_texture_path)
		else:
			sprite_2d.texture = load(REVERSE_TEXTURE_PATH)

var _y_rot := 0.0:
	set(new_value):
		_y_rot = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("y_rot", _y_rot)
		if _y_rot >= 90.0 and not face_up:
			face_up = true
		elif _y_rot < 90.0 and face_up:
			face_up = false
		

var flip_tween: Tween = null
var flip_duration := 0.2

signal controller_ready
signal card_flip_complete

const REVERSE_TEXTURE_PATH: String = "res://imported_assets/cards/Card png/reverse_01.png"

func _ready() -> void:
	_shader_mat = sprite_2d.material as ShaderMaterial
	value = self.name
	value = value.replace("Card","")
	select_rect.color.a = 0.0
	await controller_ready
	
	select_rect.mouse_entered.connect(
		func()->void:
			if game_controller.curently_active_card_uuid != "": return
			game_controller.curently_active_card_uuid = card_uuid
	)
	select_rect.mouse_exited.connect(
		func()->void:
			if game_controller.curently_active_card_uuid != card_uuid: return
			game_controller.curently_active_card_uuid = ""
	)
	
func _input(event: InputEvent) -> void:
	if game_controller.curently_active_card_uuid != card_uuid: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
			
				select_enabled = false
				_flip_card()
				await card_flip_complete
				select_enabled = true
				
				
func _flip_card():
	
	print_debug("Flippinng card with uuid ", card_uuid)
	
	if flip_tween: return
	flip_tween = create_tween()
	if face_up:
		flip_tween.tween_property(
			self,
			"_y_rot",
			0.0,
			flip_duration
		)
		flip_tween.finished.connect(
			func()->void:
				flip_tween.kill()
				flip_tween = null
				card_flip_complete.emit()
		)
	else:
		flip_tween.tween_property(
			self,
			"_y_rot",
			180.0,
			flip_duration
		)
		flip_tween.finished.connect(
			func()->void:
				flip_tween.kill()
				flip_tween = null
				card_flip_complete.emit()
		)
		
