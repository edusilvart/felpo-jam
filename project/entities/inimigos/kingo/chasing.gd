extends State
# kingo CHASING

var duration_min : float = 2
var duration_max : float = 5
var timer := Timer.new()
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	add_child(timer)
	rng.randomize()
	var duration : float = rng.randf_range(duration_min, duration_max)
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(timer_finished) 

func enter_state() -> void:
	anim_player.play('Run')
	timer.start()
	
	parent.paper_trail.emitting = true

func update_state(delta : float) -> void:
	var direction : Vector3 = (Globals.player.global_position - parent.global_position).normalized()
	var final_dir : Vector2 = Vector2(direction.x, direction.z)
	parent.apply_gravity(delta)
	parent.apply_movement(final_dir * parent.speed, parent.acceleration, delta)
	
	if Globals.player.global_position.x > parent.global_position.x and not parent.looking_right:
		parent.flip(true)
	if Globals.player.global_position.x < parent.global_position.x and parent.looking_right:
		parent.flip(false)
	
	parent.paper_trail.look_at(direction * 10, Vector3.UP)

func get_transition() -> void:
	if parent.player_range:
		if parent.attack_timer.is_stopped():
			state_machine.set_state('Attack')
		if parent.jump_timer.is_stopped():
			state_machine.set_state('Jump')

func exit_state() -> void:
	timer.stop()
	parent.paper_trail.emitting = false

func timer_finished() -> void:
	state_machine.set_state('Idle')

func anim_finished(_anim_name : String) -> void:
	pass
