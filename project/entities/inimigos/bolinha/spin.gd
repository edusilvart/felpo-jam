extends State
# bolinha ATTACK/SPIN

@onready var dust = get_parent().get_node('%Dust')

@export var damage : float = 2
@export var knockback_angle : float = -20
@export var knockback_power : float = 4
@export var heavy_attack : bool = true

var spinning_duration : float = 1.5
var timer := Timer.new()
var direction : Vector3
var spinning : bool = false

func _ready() -> void:
	add_child(timer)
	timer.wait_time = spinning_duration
	timer.one_shot = true
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	spinning = false
	anim_player.play('Spin_Start')
	
	parent.hitbox.damage = damage
	parent.hitbox.heavy_hit = heavy_attack
	
	var angle = deg_to_rad(knockback_angle)
	var knockback = Vector2(cos(angle), sin(angle)) * knockback_power
	parent.hitbox.knockback = Vector3(knockback.x, -knockback.y, 0)
	
	direction = Globals.player.global_position - parent.global_position

func update_state(delta : float) -> void:
	if spinning:
		direction = (Globals.player.global_position - parent.global_position).normalized()
		var motion = Vector2(direction.x, direction.z)
		
		parent.apply_gravity(delta)
		parent.apply_movement(motion * parent.speed, parent.acceleration * 0.5, delta)
	else:
		parent.apply_gravity(delta)
		parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	timer.stop()
	dust.emitting = false

func timer_finished() -> void:
	anim_player.play('Spin_End')
	dust.emitting = false
	parent.velocity = direction * -1
	parent.velocity.y = 2

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Spin_Start':
		anim_player.play('Spin_Loop')
		parent.velocity = direction * parent.speed * 1.5 * Vector3(1, 0, 1)
		spinning = true
		timer.start()
	if anim_name == 'Spin_End':
		state_machine.set_state('Waiting')
