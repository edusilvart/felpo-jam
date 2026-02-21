extends Item


func enter() -> void:
	if parent.HP == parent.max_HP:
		cooldown_timer.stop()
		reset_cooldown()
	else:
		parent.HP += 1
		destroy()

func exit() -> void:
	pass
