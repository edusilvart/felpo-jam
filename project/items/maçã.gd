extends Item


@onready var heal_vfx : PackedScene = preload('res://vfx/heal_vfx.tscn')

func enter() -> void:
	if parent.HP == parent.max_HP:
		cooldown_timer.stop()
		reset_cooldown()
	else:
		parent.HP += 1
		spawn_vfx()
		destroy()

func spawn_vfx() -> void:
	var vfx = heal_vfx.instantiate()
	parent.get_parent().add_child(vfx)
	vfx.start(parent.pivot.global_position)

func exit() -> void:
	pass
