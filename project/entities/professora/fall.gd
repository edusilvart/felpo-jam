extends State
# player FALL


var direction = 1
var tween

func enter_state() -> void:
	tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(parent.pivot, 'scale', Vector3(0.9, 1.1, 1), 0.3)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('attack_blue'):
		state_machine.set_state('Blue_Air')
	if event.is_action_pressed('attack_red'):
		state_machine.set_state('Red_Air')

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.move_and_slide()

func get_transition() -> void:
	if parent.is_on_floor():
		state_machine.set_state('onGround')
	else:
		if parent.velocity.y >= 0:
			state_machine.set_state('Fall')

func exit_state() -> void:
	parent.pivot.scale = Vector3.ONE
	if tween:
		tween.kill()

func anim_finished(_anim_name : String) -> void:
	pass
