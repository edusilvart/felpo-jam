extends State
# kingo DEATH



func enter_state() -> void:
	parent.queue_free()

func update_state(_delta : float) -> void:
	pass

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
