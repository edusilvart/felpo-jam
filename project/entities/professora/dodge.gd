extends State
# player DODGE



@onready var run_dust = preload('res://vfx/run_dust.tscn')

func enter_state() -> void:
	var dust = run_dust.instantiate()
	parent.add_child(dust)
	dust.start(parent.pivot.global_position)
	
	var dir_input : Vector2 = parent.get_dir_input()
	if dir_input == Vector2.ZERO:
		if parent.looking_right:
			dir_input = Vector2(1, 0)
		else:
			dir_input = Vector2(-1, 0)
	var direction : Vector2 = dir_input * parent.speed * 3
	parent.velocity = Vector3(direction.x, 0, direction.y)
	
	if parent.velocity.x < 0:
		if parent.looking_right:
			parent.flip(false)
	if parent.velocity.x > 0:
		if not parent.looking_right:
			parent.flip(true)
	
	anim_player.play('Dodge')
	parent.hurtbox.get_node('CollisionShape3D').disabled = true
	parent.can_dodge = false
	parent.dodge_timer.start()

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration * 0.7, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	if not parent.is_on_floor():
		state_machine.set_state('Fall')

func exit_state() -> void:
	var dust = run_dust.instantiate()
	parent.get_parent().add_child(dust)
	dust.start(parent.pivot.global_position)
	
	parent.hurtbox.get_node('CollisionShape3D').disabled = false

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Dodge':
		state_machine.set_state('onGround')
