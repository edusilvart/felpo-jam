extends State
# HIT


var instigator
var heavy_hit : bool
var damage : int
var knockback : Vector3

var hit_duration : float = 0.3
var timer := Timer.new()

signal hitted

func _ready() -> void:
	add_child(timer)
	timer.wait_time = hit_duration
	timer.one_shot = true
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	timer.start()
	
	var kb_dir : float = 0
	if instigator.global_position.x > parent.global_position.x:
		kb_dir = -1
	else:
		kb_dir = 1
	
	parent.velocity.x = knockback.x * kb_dir
	parent.velocity.y = knockback.y
	parent.HP -= damage
	
	if heavy_hit:
		state_machine.set_state('Flying')
	
	anim_player.play('Hit')
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	parent.pivot.scale = Vector3(0.8, 1.2, 1)
	tween.tween_property(parent.pivot, 'scale', Vector3.ONE, 0.2)
	
	hitted.emit()

func update_state(delta : float) -> void:
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)
	parent.apply_gravity(delta)

func timer_finished() -> void:
	if parent.HP > 0:
		state_machine.set_state(state_machine.get_child(0).name)
	else:
		state_machine.set_state('Death')

func exit_state() -> void:
	timer.stop()
	parent.pivot.scale = Vector3.ONE

func anim_finished(_anim_name : String) -> void:
	pass
