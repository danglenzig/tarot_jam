class_name State
extends Node

@export var transitions: Array[StateTransition]

signal state_entered
signal state_exited

func _ready() -> void:
	set_process(false)
	set_physics_process(false)

func on_enter()->void:
	state_entered.emit(self)
func on_exit()->void:
	state_exited.emit()
