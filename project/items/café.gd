extends Item


var original_speed
var duration = 3
var is_active = false

func enter() -> void:
	parent.state_machine.anim_player.speed_scale = 1.3
	original_speed = parent.speed
	parent.speed = original_speed * 1.3
	is_active = true

func update(delta) -> void:
	if is_active:
		duration -= delta
		if duration <= 0:
			exit()

func exit() -> void:
	parent.state_machine.anim_player.speed_scale = 1
	parent.speed = original_speed
	is_active = false
