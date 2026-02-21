extends State
# player JUMP


var direction : Vector2
var tween : Tween

func enter_state() -> void:
	var dir_input : Vector2 = parent.get_dir_input()
	if dir_input.x > 0:
		direction.x = 1
		parent.flip(true)
	elif dir_input.x < 0:
		direction.x = -1
		parent.flip(false)
	else:
		direction.x = 0
	
	if dir_input.y > 0:
		direction.y = 1
	elif dir_input.y < 0:
		direction.y = -1
	else:
		direction.y = 0
	
	parent.velocity.x = parent.speed * direction.x
	parent.velocity.z = parent.speed * direction.y
	parent.velocity.y = parent.jump_force
	
	parent.pivot.scale = Vector3(0.7, 1.3, 1)
	parent.flip_node.rotation.z = deg_to_rad(15 * -direction.x)
	tween = get_tree().create_tween().set_parallel(true)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(parent.pivot, 'scale', Vector3.ONE, 0.2)
	tween.tween_property(parent.flip_node, 'rotation', Vector3.ZERO, 0.5)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		state_machine.set_state('Air_Attack')
	if event.is_action_pressed('item_01'):
		if parent.item01 != null:
			parent.item01.activate()
	if event.is_action_pressed('item_02'):
		if parent.item02 != null:
			parent.item02.activate()

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.move_and_slide()

func get_transition() -> void:
	if parent.is_on_floor():
		state_machine.set_state('onGround')
	else:
		if parent.velocity.y <= 0:
			state_machine.set_state('Fall')

func exit_state() -> void:
	parent.pivot.scale = Vector3.ONE
	parent.flip_node.rotation = Vector3.ZERO
	
	if tween:
		tween.kill()

func anim_finished(_anim_name : String) -> void:
	pass
