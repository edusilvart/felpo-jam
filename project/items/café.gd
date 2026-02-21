extends Item


@onready var dust_vfx : PackedScene = preload("res://vfx/run_dust.tscn")
@onready var buff_vfx : PackedScene = preload('res://vfx/buff_vfx.tscn')
var dust
var buff
@onready var original_speed : float = Globals.player.speed
var duration = 3
var is_active = false

func enter() -> void:
	parent.state_machine.anim_player.speed_scale = 1.3
	original_speed = parent.speed
	parent.speed = original_speed * 1.3
	is_active = true
	
	dust = dust_vfx.instantiate()
	parent.add_child(dust)
	dust.position = parent.pivot.position
	dust.get_child(0).one_shot = false
	dust.get_child(0).emitting = true
	
	buff = buff_vfx.instantiate()
	parent.add_child(buff)
	buff.position = parent.pivot.position

func update(delta) -> void:
	if is_active:
		duration -= delta
		if duration <= 0:
			exit()

func exit() -> void:
	parent.state_machine.anim_player.speed_scale = 1
	parent.speed = original_speed
	is_active = false
	dust.get_child(0).one_shot = true
	for child in buff.get_children():
		child.one_shot = true
