extends State
# cachorro WAITING

@export var wait_time : float = 3.0
var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(timer_finished)
	timer.wait_time = wait_time

func enter_state() -> void:
	anim_player.play('Idle')
	timer.start()

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)
	
	if Globals.player.global_position.x > parent.global_position.x and not parent.looking_right:
		parent.flip(true)
	if Globals.player.global_position.x < parent.global_position.x and parent.looking_right:
		parent.flip(false)

func get_transition() -> void:
	if parent.player_range and parent.attack_cooldown_timer.is_stopped():
		state_machine.set_state('Attack')

func timer_finished() -> void:
	parent.assign_target()
	state_machine.set_state('Chasing')

func exit_state() -> void:
	timer.stop()

func anim_finished(_anim_name : String) -> void:
	pass
