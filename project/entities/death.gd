extends State
# DEATH


@onready var carimbo_VFX : PackedScene = preload("res://vfx/carimbo.tscn")

func enter_state() -> void:
	var vfx = carimbo_VFX.instantiate()
	parent.get_parent().add_child(vfx)
	vfx.start(parent.global_position)
	
	parent.died.emit()
	parent.call_deferred('queue_free')
	
	if not parent == Globals.player:
		Globals.kills += 1

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration * 2, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
