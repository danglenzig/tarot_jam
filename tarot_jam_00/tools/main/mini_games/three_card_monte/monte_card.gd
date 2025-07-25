class_name MonteCard
extends Node2D

@onready var select_rect: SelectRect = $SelectRect
@onready var card_uuid: String = SingletonHolder.misc_tools.get_uuid()

@onready var sprite_2d: Sprite2D =$CardSprite

signal win_signal
signal lose_signal(losing_card: MonteCard)

@export var is_target_card := false

var value := ""
var game_controller: ThreeCardMonte = null:
	set(new_value):
		game_controller = new_value
		if game_controller:
			controller_ready.emit()
			
var select_enabled := false:
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
var flip_duration := 0.1

signal controller_ready
signal card_flip_complete

const REVERSE_TEXTURE_PATH: String = "res://imported_assets/cards/Card png/reverse_01.png"
const HIGHLIGHT_DURATION := 0.25
const HIGHLIGHT_REPEAT := 3

func _ready() -> void:
	
	if has_node("RedX"):
		($RedX as Sprite2D).visible = false
	if has_node("HighlightRect"):
		($HighlightRect as ColorRect).visible = false
	
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
	if not game_controller: return
	if game_controller.curently_active_card_uuid != card_uuid: return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				
				if not select_enabled: return
				
				if game_controller.always_lose:
					_on_auto_lose()
					return
					
				
			
				select_enabled = false
				_flip_card()
				await card_flip_complete
				
				if is_target_card:
					win_signal.emit()
				else:
					lose_signal.emit(self)
					
				
				#select_enabled = true
				

func _on_auto_lose():
	
	face_texture_path = (
		# the fool
		SingletonHolder.deck_helper.face_up_data[0]["texture_path"]
	)
	_flip_card()
	await card_flip_complete
	lose_signal.emit(self)

func _flip_card():
	var sm: SoundManager = SingletonHolder.game_manager.main.sound_manager
	
	print_debug("Flippinng card with uuid ", card_uuid)
	
	if flip_tween: return
	flip_tween = create_tween()
	sm.tween_up_sine_tone(flip_duration)
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
		
func highlight_sequence(flip_card: bool)->bool:
	assert(is_target_card)
	assert(has_node("HighlightRect"))
	if flip_card:
		_show_card()
	for i in range(HIGHLIGHT_REPEAT + 1):
		await get_tree().create_timer(HIGHLIGHT_DURATION * 0.5).timeout
		print_debug("ON")
		($HighlightRect as ColorRect).visible = true
		await get_tree().create_timer(HIGHLIGHT_DURATION).timeout
		print_debug("OFF")
		($HighlightRect as ColorRect).visible = false
	return true
	
func display_x_sequence()->bool:
	#assert(not is_target_card)
	assert(has_node("RedX"))
	
	var wait_time = ((HIGHLIGHT_DURATION * 0.5) + HIGHLIGHT_DURATION) * HIGHLIGHT_REPEAT
	($RedX as Sprite2D).visible = true
	await get_tree().create_timer(wait_time).timeout
	($RedX as Sprite2D).visible = false
	
	return true
	
func _show_card():
	_flip_card()
	await card_flip_complete
	await get_tree().create_timer(HIGHLIGHT_DURATION * 4).timeout
	_flip_card()
	
		
