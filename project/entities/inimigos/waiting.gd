extends State
# enemy WAITING

@export var min_wait_time : float = 0.2
@export var max_wait_time : float = 1.5
var timer := Timer.new()
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	if prev_state == 'Flying':
		anim_player.play('Get_Up')
	else:
		anim_player.play('Idle')
	
	rng.randomize()
	timer.wait_time = rng.randf_range(min_wait_time, max_wait_time)
	timer.start()

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)
	
	if Globals.player.global_position.x > parent.global_position.x and not parent.looking_right:
		parent.flip(true)
	if Globals.player.global_position.x < parent.global_position.x and parent.looking_right:
		parent.flip(false)

func get_transition() -> void:
	if not parent.is_on_floor():
		state_machine.set_state('Fall')
	#if parent.player_range and parent.attack_cooldown_timer.is_stopped():
		#state_machine.set_state('Attack')

func timer_finished() -> void:
	state_machine.set_state('Chasing')

func exit_state() -> void:
	timer.stop()

func anim_finished(_anim_name : String) -> void:
	pass
