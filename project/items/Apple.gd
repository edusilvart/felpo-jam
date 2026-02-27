extends Item


@onready var heal_vfx : PackedScene = preload('res://vfx/heal_vfx.tscn')

func enter() -> void:
	parent.HP = clamp(parent.HP + 3, 0, parent.max_HP)
	Globals.HUD.HP_bar.max_value = parent.max_HP
	Globals.HUD.HP_bar.value = parent.HP
	spawn_vfx()
	destroy()

func can_use() -> bool:
	if parent.HP == parent.max_HP:
		return false
	else:
		return true

func spawn_vfx() -> void:
	var vfx = heal_vfx.instantiate()
	parent.get_parent().add_child(vfx)
	vfx.start(parent.pivot.global_position)

func exit() -> void:
	pass
