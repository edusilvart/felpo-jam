extends Item


@onready var dust_vfx : PackedScene = preload("res://vfx/run_dust.tscn")
@onready var buff_vfx : PackedScene = preload('res://vfx/buff_vfx.tscn')
var dust
var buff
@onready var original_speed : float = Globals.player.speed
var duration = 8
var is_active = false

func enter() -> void:
	original_speed = parent.speed
	parent.state_machine.anim_player.speed_scale = 1.4
	parent.speed = original_speed * 1.4
	is_active = true
	
	dust = dust_vfx.instantiate()
	parent.add_child(dust)
	dust.position = parent.pivot.position
	dust.get_child(0).one_shot = false
	dust.get_child(0).emitting = true
	
	buff = buff_vfx.instantiate()
	parent.add_child(buff)
	buff.position = parent.pivot.position

func can_use() -> bool:
	if not is_active:
		return true
	else:
		return false

func update(delta: float) -> void:
	if is_active:
		duration -= delta
		if duration <= 0:
			destroy()

func exit() -> void:
	parent.state_machine.anim_player.speed_scale = 1
	parent.speed = original_speed
	if is_active:
		dust.get_child(0).one_shot = true
		for child in buff.get_children():
			child.one_shot = true
	
	is_active = false
