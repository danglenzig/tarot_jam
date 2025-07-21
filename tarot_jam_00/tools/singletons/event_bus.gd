class_name EventBus
extends Node

@warning_ignore("unused_signal")
signal start_dialogue_signal(convo: Conversation, start_index: int)
@warning_ignore("unused_signal")
signal dialogue_started
@warning_ignore("unused_signal")
signal dialogue_ended(uuid_string: String)
@warning_ignore("unused_signal")
signal dialogue_line_updated(speaker_sprite_side: int , speaker_texture: Texture)
