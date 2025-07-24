class_name Conversation
extends Node

@export var dialogue_lines: Array[DialogueLine]
var conversation_uuid: String = ""

@onready var convo_uuid: String = SingletonHolder.misc_tools.get_uuid()

@export var begin_convo_signal_data_string := ""
@export var end_convo_signal_data_string := ""
