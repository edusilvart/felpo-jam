extends Node
class_name StateMachine


@export var parent_path : NodePath
@warning_ignore("untyped_declaration")
@onready var parent = get_node(parent_path)
@export var anim_player_path : NodePath
@warning_ignore("untyped_declaration")
@onready var anim_player = get_node(anim_player_path)

var state : Node = null
var prev_state : Node = null

func _ready() -> void:
	for child : Node in get_children():
		if child is State:
			child.parent = parent
			child.anim_player = anim_player
			
			anim_player.animation_finished.connect(child.anim_finished)
			child.set_process(false)
			child.set_physics_process(false)
			child.set_process_input(false)
			child.set_process_unhandled_input(false)
	
	state = get_child(0)
	await parent.ready
	set_state(get_child(0).name)

func set_state(newState: String) -> void:
	prev_state = state
	state.exit_state()
	state.set_process(false)
	state.set_physics_process(false)
	state.set_process_input(false)
	state.set_process_unhandled_input(false)
	
	state = get_node(newState)
	
	state.prev_state = prev_state.name
	state.enter_state()
	state.set_process(true)
	state.set_physics_process(true)
	state.set_process_input(true)
	state.set_process_unhandled_input(true)

func _physics_process(delta : float) -> void:
	state.update_state(delta)
	state.get_transition()

func enter_state() -> void:
	pass

func update_state(_delta : float) -> void:
	pass

func get_transition() -> void:
	pass

func exit_state() -> void:
	state.exit_state()
