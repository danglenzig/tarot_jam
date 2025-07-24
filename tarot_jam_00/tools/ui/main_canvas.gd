class_name MainCanvas
extends CanvasLayer

@onready var hud: Hud = %Hud
@onready var start_menu: StartMenu = %StartMenu
@onready var transition_screen: Control = %TransitionScreen
@onready var logo_splash: LogoSplash = %LogoSplash
@onready var dialogue: Dialogue = %Dialogue
@onready var theme_alert: ThemeAlert = $ThemeAlert
@onready var general_knowledge: GeneralKnowledge = $GeneralKnowledge
@onready var master_mind: MastermindLabel = $MasterMind
@onready var memory: MemoryLabel = %Memory


@onready var event_bus: EventBus = SingletonHolder.event_bus


func _ready() -> void:
	hide_all_layers()
	
	event_bus.dialogue_started.connect(_on_dialogue_started)
	event_bus.dialogue_ended.connect(_on_dialogue_ended)

func show_layer(the_layer: Control, show_value: bool, hide_others: bool = false):
	var layers := get_children()
	if hide_others:
		hide_all_layers()
	assert(the_layer in layers)
	the_layer.visible = show_value

func hide_all_layers():
	var layers := get_children()
	for child_layer: Control in layers:
		child_layer.visible = false
		
func _on_dialogue_started():
	show_layer(dialogue,true)
	
func _on_dialogue_ended(_uuid: String):
	show_layer(dialogue, false)
