extends State
# kingo IDLE

var duration_min : float = 1
var duration_max : float = 2
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
	anim_player.play('Idle')
	timer.start()

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	
	if Globals.player.global_position.x > parent.global_position.x and not parent.looking_right:
		parent.flip(true)
	if Globals.player.global_position.x < parent.global_position.x and parent.looking_right:
		parent.flip(false)

func get_transition() -> void:
	if parent.player_range:
		if parent.attack_timer.is_stopped():
			state_machine.set_state('Attack')
		if parent.jump_timer.is_stopped():
			state_machine.set_state('Jump')

func exit_state() -> void:
	timer.stop()

func timer_finished() -> void:
	state_machine.set_state(get_random_state())

func get_random_state() -> String:
	var states = ['Chasing']
	if parent.shoot_timer.is_stopped():
		states.append('Shoot')
	if parent.shoot_timer.is_stopped():
		states.append('Jump')
	if parent.shoot_timer.is_stopped():
		states.append('Shout')
	
	var random_state : String = states.pick_random()
	
	return random_state

func anim_finished(_anim_name : String) -> void:
	pass
