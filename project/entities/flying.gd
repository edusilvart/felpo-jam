extends State
# FLYING

var wakeup_timer := Timer.new()
var flying : bool
var rotate_speed : float = 0.15
var slow_down : float = 2
var direction : float = 1

func _ready() -> void:
	add_child(wakeup_timer)
	wakeup_timer.wait_time = 1
	wakeup_timer.timeout.connect(timer_finished)

func enter_state() -> void:
	flying = true
	anim_player.play('Flying')
	
	if parent.looking_right:
		direction = -1
	else:
		direction = 1

func update_state(delta : float) -> void:
	if flying:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, slow_down * delta)
	else:
		parent.velocity.x = lerp(parent.velocity.x, 0.0, slow_down * 10 * delta)
	parent.velocity.z = lerp(parent.velocity.z, 0.0, slow_down * 3 * delta)
	parent.apply_gravity(delta)
	parent.move_and_slide()
	
	if flying:
		parent.flip_node.rotation.z -= rotate_speed * direction

func get_transition() -> void:
	if parent.is_on_floor() and flying:
		parent.hurtbox.get_node('CollisionShape3D').disabled = true
		wakeup_timer.start()
		parent.flip_node.rotation.z = 0
		anim_player.play('Laying')
		var tween := get_tree().create_tween()
		tween.set_ease(Tween.EASE_OUT)
		tween.set_trans(Tween.TRANS_CUBIC)
		parent.pivot.scale = Vector3(1.3, 0.7, 0)
		tween.tween_property(parent.pivot, 'scale', Vector3.ONE, 0.3)
		
		flying = false

func timer_finished() -> void:
	if parent.HP > 0:
		state_machine.set_state(state_machine.get_child(0).name)
		parent.hurtbox.get_node('CollisionShape3D').disabled = false
	else:
		state_machine.set_state('Death')

func exit_state() -> void:
	parent.flip_node.rotation.z = 0
	parent.pivot.scale = Vector3.ONE
	wakeup_timer.stop()

func anim_finished(_anim_name : String) -> void:
	pass
