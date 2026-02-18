extends State
# enemy CHASING


var direction : Vector3

func enter_state() -> void:
	pass

func update_state(delta : float) -> void:
	direction = (Globals.player.global_position - parent.global_position).normalized()
	parent.apply_movement(Vector2(direction.x, direction.z) * parent.speed, parent.acceleration, delta)
	parent.apply_gravity(delta)
	
	if direction.x > 0 and not parent.looking_right:
		parent.flip(true)
	if direction.x < 0 and parent.looking_right:
		parent.flip(false)

func get_transition() -> void:
	if parent.player_range and parent.attack_cooldown_timer.is_stopped():
		state_machine.set_state('Attack')

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
