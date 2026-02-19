extends State
# DEATH



func enter_state() -> void:
	parent.died.emit()
	parent.hurtbox.call_deferred('queue_free')

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
