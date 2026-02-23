extends Item


var knockback_direction = 30
var knockback_power = 4

var fall_velocity : float = 6
var attacking : bool = false
var jumping : bool = false
var start_pos : Vector3
var jump_height : float = 0.6
var air_hold : float = 0.1 # how long it holds in air before attacking

func enter() -> void:
	parent.state_machine.set_state('Waiting')
	parent.velocity = Vector3.ZERO
	
	if parent.is_on_floor():
		start_pos = parent.global_position
		parent.velocity.y = parent.jump_force
		parent.get_node('AnimationPlayer').play('Jump')
		jumping = true
	else:
		parent.state_machine.set_state('Stomp')

func update(delta) -> void:
	if attacking:
		parent.move_and_slide()
		
		if parent.is_on_floor():
			parent.state_machine.set_state('onGround')
			attacking = false
	if jumping:
		parent.move_and_slide()
		if parent.global_position.y >= start_pos.y + jump_height:
			parent.velocity.y = 0
			air_hold -= delta
			if air_hold <= 0:
				parent.state_machine.set_state('Stomp')
				jumping = false
			

func exit() -> void:
	pass
