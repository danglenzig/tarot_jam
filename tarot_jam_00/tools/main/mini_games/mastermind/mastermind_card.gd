class_name MastermindCard
extends Control

@onready var highlight_color_rect: ColorRect = $HighlightColorRect
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var select_rect: SelectRect = $SelectRect
@onready var card_uuid: String = SingletonHolder.misc_tools.get_uuid()

var game_controller: MastermindGame = null:
	set(new_value):
		game_controller = new_value
		if game_controller:
			controller_ready.emit()

signal controller_ready

func _ready() -> void:
	
	await controller_ready
	
	select_rect.clicked.connect(_on_select_rect_clicked)
	
	select_rect.mouse_entered.connect(
		func()->void:
			if not game_controller.select_mode: return
			if game_controller.active_symbol_rect_uuid != "": return
			game_controller.active_symbol_rect_uuid = card_uuid
	)
	select_rect.mouse_exited.connect(
		func()->void:
			if game_controller.active_symbol_rect_uuid != card_uuid: return
			game_controller.active_symbol_rect_uuid = ""
	)
	game_controller.symbol_dropped.connect(_on_symbol_dropped)
	
	
func _on_select_rect_clicked():
	if game_controller.active_symbol_rect_uuid != card_uuid: return
	game_controller.select_mode = false
	
	game_controller.symbol_clicked.emit(card_uuid)
	sprite_2d.self_modulate.a = 0.0
	# handle mouse_chaser
	var mc:= game_controller.mouse_chaser
	mc.texture = sprite_2d.texture
	mc.visible = true
	
func _on_symbol_dropped(uuid: String, idx: int):
	if uuid != card_uuid: return
	select_rect.mouse_filter = Control.MOUSE_FILTER_STOP
	sprite_2d.self_modulate.a = 1.0
	sprite_2d.texture = game_controller.get_texture_of_symbol_at_idx(idx)
