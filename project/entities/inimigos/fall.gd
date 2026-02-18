extends State
# enemy FALL



func enter_state() -> void:
	pass
	#anim_player.play('Fall')

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	if parent.is_on_floor():
		state_machine.set_state('Waiting')

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
