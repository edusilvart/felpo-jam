extends State
# cachorro ENTER


func enter_state() -> void:
	if prev_state == 'Attack':
		state_machine.set_state('Leave')
	else:
		anim_player.play('Idle')
		parent.assign_target()
		state_machine.get_node('Chasing').target = parent.target
		state_machine.set_state('Chasing')

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	if parent.player_range and parent.attack_cooldown_timer.is_stopped():
		state_machine.set_state('Attack')

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
