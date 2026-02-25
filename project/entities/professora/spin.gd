extends State
# player SPIN


@export var audioclips : Array[AudioStream] = []
@export var voiceclips : Array[AudioStream] = []

var duration : float = 1
var duration_timer := Timer.new()

func _ready() -> void:
	add_child(duration_timer)
	duration_timer.timeout.connect(timer_finished)
	duration_timer.one_shot = true
	duration_timer.wait_time = duration

func custom_movement(delta) -> void:
	var dir : Vector2 = parent.get_dir_input()
	parent.apply_movement(dir * parent.speed, parent.acceleration * 0.5, delta)

func enter_state() -> void:
	anim_player.play('Spin_Start')
	
	if not audioclips.is_empty():
		var audio = audioclips.pick_random()
		SFX_MANAGER.play_sfx_at(audio, parent.global_position, 0, 0.95, 1.05)
	if not voiceclips.is_empty():
		var audio = voiceclips.pick_random()
		SFX_MANAGER.play_sfx_at(audio, parent.global_position, 0, 0.95, 1.05)

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(parent.get_dir_input() * parent.speed * 0.5, parent.acceleration * 0.5, delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	duration_timer.stop()

func timer_finished() -> void:
	anim_player.play('Spin_End')

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Spin_Start':
		anim_player.play('Spin_Loop')
		duration_timer.start()
	if anim_name == 'Spin_End':
		state_machine.set_state('onGround')
