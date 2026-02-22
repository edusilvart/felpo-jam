extends State
# cachorro ENTER


var timer := Timer.new()
var delay : float = 0.6

func _ready() -> void:
	add_child(timer)
	timer.wait_time = delay
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	anim_player.play('Idle')
	timer.start()

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)

func get_transition() -> void:
	pass

func timer_finished() -> void:
	parent.queue_free()

func exit_state() -> void:
	pass

func anim_finished(_anim_name : String) -> void:
	pass
