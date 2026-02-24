extends State


@onready var lapis_scn = preload('res://entities/inimigos/Avião/lapis.tscn')

var direction : Vector3
var drop_offset : float = 1
var timer := Timer.new()
var update_direction_time : float = 0.8
var direction_timer := Timer.new()
var height : float = 1.2
var start_pos : Vector3
var fly_speed : float = 1

func _ready() -> void:
	add_child(timer)
	timer.wait_time = drop_offset
	timer.one_shot = false
	timer.timeout.connect(timer_finished)
	
	add_child(direction_timer)
	direction_timer.wait_time = update_direction_time
	direction_timer.one_shot = false
	direction_timer.timeout.connect(update_direction)
	
	start_pos = get_parent().get_parent().global_position

func enter_state() -> void:
	anim_player.play('Idle')
	timer.start()
	direction_timer.start()

func update_direction() -> void:
	direction = (Globals.player.global_position - parent.global_position).normalized()

func update_state(delta : float) -> void:
	if parent.global_position.y <= start_pos.y + height:
		parent.velocity.y = lerp(parent.velocity.y, parent.speed * 0.1, fly_speed * delta)
	if parent.global_position.y >= start_pos.y + height:
		parent.velocity.y = lerp(parent.velocity.y, 0.0, fly_speed * delta)
	
	var motion = Vector2(direction.x, direction.z)
	
	parent.apply_movement(motion, parent.acceleration, delta)
	
	if direction.x > 0 and not parent.looking_right:
		parent.flip(true)
	if direction.x < 0 and parent.looking_right:
		parent.flip(false)

func get_transition() -> void:
	pass

func exit_state() -> void:
	timer.stop()
	direction_timer.stop()

func timer_finished() -> void:
	var lapis = lapis_scn.instantiate()
	parent.get_parent().add_child(lapis)
	lapis.global_position = parent.pivot.global_position

func anim_finished(_anim_name : String) -> void:
	pass
