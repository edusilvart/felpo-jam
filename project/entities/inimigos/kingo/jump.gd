extends State
# kingo JUMP


@onready var land_vfx : PackedScene = preload('res://vfx/kingo_land.tscn')

@export var land_sfx : AudioStream

var follow_speed : float = 5 # follow player on air
var follow_duration : float = 2
var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = follow_duration
	timer.one_shot = true
	timer.timeout.connect(timer_finished)

func enter_state() -> void:
	anim_player.play('Jump')
	
	parent.hitbox.instigator = parent
	parent.hitbox.heavy_hit = true
	parent.hitbox.damage = 3
	var angle = deg_to_rad(-30)
	var knockback = Vector2(cos(angle), sin(angle)) * 6
	parent.hitbox.knockback = Vector3(knockback.x, -knockback.y, 0)

func update_state(delta : float) -> void:
	if not timer.is_stopped():
		parent.global_position.x = lerp(parent.global_position.x, Globals.player.position.x, follow_speed * delta)
		parent.global_position.z = lerp(parent.global_position.z, Globals.player.position.z, follow_speed * delta)
	
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	parent.pivot.scale = Vector3.ONE
	parent.jump_timer.start()

func timer_finished() -> void:
	anim_player.play('Land')

func landed() -> void:
	Globals.camera.shake = 1
	var vfx = land_vfx.instantiate()
	parent.get_parent().add_child(vfx)
	vfx.start(parent.pivot.global_position)
	
	SFX_MANAGER.play_sfx_at(land_sfx, parent.global_position, 0, 0.85, 1.1)

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Jump':
		timer.start()
	if anim_name == 'Land':
		state_machine.set_state('Idle')
