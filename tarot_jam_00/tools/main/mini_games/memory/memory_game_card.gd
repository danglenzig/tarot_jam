
class_name MemoryGameCard
extends Control

@onready var card_sprite: Sprite2D = $CardSprite
@onready var card_uuid: String = SingletonHolder.misc_tools.get_uuid()
@onready var select_rect: SelectRect = $SelectRect


var _reverse_texture: Texture
var _face_texture: Texture
var _shader_mat: ShaderMaterial = null
var selectable := false

var flip_tween: Tween = null

var game_controller: MemoryGame = null:
	set(new_value):
		game_controller = new_value
		if game_controller:
			controller_ready.emit()

var face_up := false:
	set(new_value):
		face_up = new_value
		if face_up:
			card_sprite.texture = _face_texture
			#card_sprite.flip_h = true
		else:
			card_sprite.texture = _reverse_texture
			#card_sprite.flip_h = false
			_y_rot = 0.0

var _y_rot := 0.0:
	set(new_value):
		assert(new_value <= 180.0 and new_value >= 0.0)
		_y_rot = new_value
		if not _shader_mat: return
		_shader_mat.set_shader_parameter("y_rot", _y_rot)
		if(
			_y_rot >= 90.0 and 
			not face_up
		):
			face_up = true
		elif (
			_y_rot < 90.0 and 
			face_up
		):
			face_up = false

var face_value := -1:
	set(new_value):
		assert(new_value in SingletonHolder.deck_helper.face_up_data.keys())
		face_value = new_value
		var tex_path: String = SingletonHolder.deck_helper.face_up_data[face_value]["texture_path"]
		_face_texture = load(tex_path)
		

signal controller_ready
signal card_selected(card: MemoryGameCard)

const FLIP_DURATION := 0.1

func _ready() -> void:
	
	visible = false
	_shader_mat = card_sprite.material as ShaderMaterial
	var reverse_texture_path = SingletonHolder.deck_helper.reverse_face_texture_path
	_reverse_texture = load(reverse_texture_path)
	
	await controller_ready
	
	visible = true
	
	select_rect.mouse_entered.connect(_on_mouse_entered)
	select_rect.mouse_exited.connect(_on_mouse_exited)
	select_rect.clicked.connect(_on_select_area_clicked)
	
	
func _on_mouse_entered():
	if game_controller.current_card_hovered_uuid != "": return
	game_controller.current_card_hovered_uuid = card_uuid
	
func _on_mouse_exited():
	if game_controller.current_card_hovered_uuid != card_uuid: return
	game_controller.current_card_hovered_uuid = ""
	
func flip_to_face_down()->bool:
	if not face_up: return true
	
	#assert(flip_tween == null)
	# fucking why????
	if flip_tween:
		flip_tween.kill()
		flip_tween = null
	
	flip_tween = create_tween()
	card_sprite.z_index = 1
	flip_tween.tween_property(
		self,
		"_y_rot",
		0.0,
		FLIP_DURATION
	)
	await flip_tween.finished
	flip_tween.kill()
	flip_tween = null
	card_sprite.z_index = 0
	return true
	
func flip_to_face_up()->bool:
	if face_up:
		print_debug("already face up")
		return true
	assert(not flip_tween)
	flip_tween = create_tween()
	card_sprite.z_index = 1
	flip_tween.tween_property(
		self,
		"_y_rot",
		180.0,
		FLIP_DURATION
	)
	await flip_tween.finished
	flip_tween.kill()
	flip_tween = null
	card_sprite.z_index = 0
	return true
	
func _on_select_area_clicked():
	
	
	
	if not selectable: return
	
	
	
	if game_controller.current_card_hovered_uuid != card_uuid: return
	
	print_debug(card_uuid)
	
	selectable = false
	await flip_to_face_up()
	
	card_selected.emit(self)
	
func remove_card()->bool:
	card_sprite.visible = false
	select_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	await get_tree().create_timer(0.1).timeout # replace with disolve shader tween
	return true
	
	
	
	
