extends State
# kingo IDLE



func enter_state() -> void:
	state_machine.set_state('Idle')

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration * delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
