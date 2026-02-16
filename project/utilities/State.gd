extends Node
class_name State


@warning_ignore("untyped_declaration")
@onready var state_machine = get_parent()
@warning_ignore("untyped_declaration")
var parent

@warning_ignore("untyped_declaration")
var anim_player
var prev_state : String = ''

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	set_process_unhandled_input(false)

func _physics_process(_delta : float) -> void:
	pass

func enter_state() -> void:
	pass

func update_state(_delta : float) -> void:
	pass

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
