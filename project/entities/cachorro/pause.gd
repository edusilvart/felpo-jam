extends State
# cachorro PAUSE (for shop state etc)


func enter_state() -> void:
	anim_player.play('Idle')

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
