extends Item


var attacking : bool = false

func enter() -> void:
	parent.state_machine.set_state('Spin')

func update(_delta) -> void:
	pass

func exit() -> void:
	pass
