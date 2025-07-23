class_name Dialogue
extends Control

enum EnumClickAction {ADVANCE, END}

@onready var dialogue_ui: Panel = %DialogueUi
@onready var event_bus: EventBus = SingletonHolder.event_bus
@onready var dialogue_text: RichTextLabel = %DialogueText
@onready var dialog_choices_vbox: VBoxContainer = %DialogChoicesVbox
@onready var speaker_name_label: Label = %SpeakerNameLabel

var current_click_action: EnumClickAction = EnumClickAction.END

#@warning_ignore("unused_signal")
#signal dialogue_choice_taken(data: String)

#@warning_ignore("unused_signal")
#signal line_finished_signal(data: String)
signal dialogue_data_signal(data: String)

var current_convo: Conversation = null:
	set(new_value):
		
		if new_value != null:
			current_convo = new_value
			event_bus.dialogue_started.emit()
		else:
			assert(current_convo)
			event_bus.dialogue_ended.emit(current_convo.conversation_uuid)
			current_convo = new_value
		
		#current_convo = new_value
		#if current_convo:
		#	event_bus.dialogue_started.emit()
		#else:
		#	event_bus.dialogue_ended.emit()
			
var current_line_index := -1
var dialogue_text_tween: Tween = null
var listen_for_click := false

const SHOW_TEXT_INTERVAL := 0.025

signal dialogue_ended(uuid: String)
signal end_dialogue


func _ready() -> void:
	dialogue_ui.size = get_viewport_rect().size
	get_viewport().size_changed.connect(
		func()->void:
			dialogue_ui.size = get_viewport_rect().size
	)
	speaker_name_label.text = ""
	await _clear_buttons()
	event_bus.start_dialogue_signal.connect(_start_dialogue)
	

func _input(event: InputEvent) -> void:
	if not current_convo: return
	if not listen_for_click: return
	if (
		event is InputEventMouseButton and
		event.button_index == MOUSE_BUTTON_LEFT and
		event.is_pressed()
	):
		match  current_click_action:
			EnumClickAction.ADVANCE:
				_advance_dialogue()
			EnumClickAction.END:
				_end_dialogue()
	

func _advance_dialogue():
	assert(current_convo, "No conversation")
	assert(
		current_line_index + 1 < current_convo.dialogue_lines.size(),
		"There is no next line"
	)
	current_line_index += 1
	var dialogue_line := _get_dialogue_line(current_line_index)
	_handle_text(dialogue_line)

func _start_dialogue(convo: Conversation, start_index: int = 0):
	
	call_deferred("add_child", convo)
	await convo.tree_entered
	
	current_convo = convo
	current_line_index = start_index
	var dialogue_line := _get_dialogue_line(start_index)
	_handle_text(dialogue_line)
	

	
func _end_dialogue():
	assert(current_convo, "No conversation")
	
	dialogue_ended.emit(current_convo.convo_uuid)
	current_convo.call_deferred("queue_free")
	await current_convo.tree_exited
	
	current_convo = null
	current_line_index = -1
	listen_for_click = false
	current_click_action = EnumClickAction.END
	
	SingletonHolder.game_manager.main.main_canvas.show_layer(self, false)
	
func _handle_speaker_label(line: DialogueLine):
	speaker_name_label.text = line.speaker_name
	
func _handle_text(line: DialogueLine):
	
	_handle_speaker_label(line)
	
	if line.begin_signal_data_string.length() > 0:
		dialogue_data_signal.emit(line.begin_signal_data_string)
	
	var side = line.portrait_side
	var texture = line.portrait_texture
	if line.portrait_texture:
		event_bus.dialogue_line_updated.emit(side, texture) # game_environment listens for this
	else:
		event_bus.dialogue_line_updated.emit(side, null)
	
	_clear_buttons()
	dialogue_text.visible_ratio = 0.0
	dialogue_text.text = line.text
	if dialogue_text_tween:
		dialogue_text_tween.kill()
		dialogue_text_tween = null
	listen_for_click = false
	dialogue_text_tween = create_tween()
	dialogue_text_tween.tween_property(
		dialogue_text,
		"visible_ratio",
		1.0,
		(SHOW_TEXT_INTERVAL * line.text.length())
	)
	dialogue_text_tween.finished.connect(
		func()->void:
			if line.end_signal_data_string.length()>0:
				dialogue_data_signal.emit(line.end_signal_data_string)
			
			if line.is_quit:
				current_click_action = EnumClickAction.END
			else:
				current_click_action = EnumClickAction.ADVANCE
				
			if line.choices.is_empty():
				listen_for_click = true
			else:
				listen_for_click = false
				_setup_buttons()
	)
	
	
func _setup_buttons():
	await _clear_buttons()
	assert(current_convo, "No conversation")
	assert(
		not current_convo.dialogue_lines[current_line_index].choices.is_empty(),
		str(
			"No choices of line ",
			current_convo.dialogue_lines[current_line_index].text
		)
	)
	var choices: Array[DialogueChoice] = current_convo.dialogue_lines[current_line_index].choices
	for choice in choices:
		var new_button := Button.new()
		dialog_choices_vbox.call_deferred("add_child", new_button)
		await  new_button.tree_entered
		new_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		new_button.text = choice.text
		if choice.is_quit:
			new_button.pressed.connect(
				func()->void:
					if choice.signal_data_string != "":
						dialogue_data_signal.emit(choice.signal_data_string)
					_end_dialogue()
			)
		else:
			new_button.pressed.connect(
				func()->void:
					if choice.signal_data_string != "":
						dialogue_data_signal.emit(choice.signal_data_string)
					current_line_index = choice.target_line_index
					var new_line := _get_dialogue_line(choice.target_line_index)
					_handle_text(new_line)
			)
		
	
	
func _get_dialogue_line(idx: int)->DialogueLine:
	assert(current_convo)
	return current_convo.dialogue_lines[idx]

func _clear_buttons()->bool:
	for button: Button in dialog_choices_vbox.get_children():
		button.call_deferred("queue_free")
		await button.tree_exited
	return true
