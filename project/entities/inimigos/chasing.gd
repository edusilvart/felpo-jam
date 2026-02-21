extends State
# enemy CHASING


var target : CharacterBody3D
var direction : Vector3
var max_chasing_duration : float = 2
var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = max_chasing_duration
	timer.one_shot = true
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	timer.start()
	anim_player.play('Run')

func update_state(delta : float) -> void:
	if target != null:
		direction = (target.global_position - parent.global_position).normalized()
		parent.apply_movement(Vector2(direction.x, direction.z) * parent.speed, parent.acceleration, delta)
		parent.apply_gravity(delta)
	
	if direction.x > 0 and not parent.looking_right:
		parent.flip(true)
	if direction.x < 0 and parent.looking_right:
		parent.flip(false)

func get_transition() -> void:
	if parent.player_range and parent.attack_cooldown_timer.is_stopped():
		state_machine.set_state('Attack')

func timer_finished() -> void:
	state_machine.set_state('Waiting')

func exit_state() -> void:
	timer.stop()

func anim_finished(_anim_name : String) -> void:
	pass
