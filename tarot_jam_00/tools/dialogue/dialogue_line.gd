class_name DialogueLine
extends Node

enum PortaitSide {LEFT, RIGHT}

@export_category("General")
@export var speaker_name := "Namey Nameson"
@export var portrait_texture: Texture = null
@export var texture_offset: Vector2 = Vector2.ZERO
#@export_enum("LEFT", "RIGHT") var portrait_side = 0
@export var portrait_side: PortaitSide = PortaitSide.LEFT
@export_multiline var text := "This is the words the speaker is saying on this line"
@export var is_quit := false

@export var begin_signal_data_string := ""
@export var end_signal_data_string := ""


@export_category("Choices")
@export var choices: Array[DialogueChoice]
