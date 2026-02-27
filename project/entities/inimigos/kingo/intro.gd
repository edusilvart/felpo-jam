extends State
# kingo IDLE


var duration : float = 3
var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = duration
	timer.one_shot = true
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	anim_player.play('Intro')
	Globals.player.state_machine.set_state('Waiting')
	Globals.camera.target = parent
	timer.start()

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	Globals.player.state_machine.set_state('onGround')
	Globals.camera.target = Globals.player

func timer_finished() -> void:
	state_machine.set_state('Idle')

func anim_finished(_anim_name : String) -> void:
	pass
