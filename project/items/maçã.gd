extends Item


func enter() -> void:
	if parent.HP < parent.max_HP:
		cooldown_timer.stop()
	else:
		parent.HP += 1
		destroy()

func exit() -> void:
	pass
