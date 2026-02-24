class_name Attack extends State
# player ATTACK

@export var air_attack : bool = false # if true will apply gravity
@export var damage : int = 0
@export var knockback_direction : float # direction in degrees. (-1 = follow hitbox)
@export var knockback_power : float
@export var movement_speed : Vector2 = Vector2(0, 0)
@export var movement_duration : float = 0.0
@export var heavy_attack : bool = false # Different types of knockback, if heavy will knockback
var runtime : float = 0
@export var movement_curve : Curve
@export var chain : int = 0 # next combo attack to be chained || 0 = end chain
@export var projectile : bool = false # should spawn projectile
@export var projectile_scene : PackedScene

@export var audioclips : Array[AudioStream] = []

var input_lock : float = false
var action_buffered : String = ''
var buffer_reset_max : float = 0.25
var buffer_reset : float = 0.0
var direction : int = 1 # direction the character is facing

#KNOCKBACK IS - DIRECTION * POWER * DIRECTION (1 or -1)

func enter_state() -> void:
	anim_player.play(name)
	input_lock = true
	action_buffered = ''
	buffer_reset = 0
	runtime = 0
	
	if parent.looking_right:
		direction = 1
	else:
		direction = -1
	
	parent.hitbox.damage = damage
	var angle = deg_to_rad(knockback_direction)
	var knockback = Vector2(cos(angle), sin(angle)) * knockback_power
	parent.hitbox.knockback = Vector3(knockback.x, -knockback.y, 0)
	parent.hitbox.heavy_hit = heavy_attack
	
	if not parent == Globals.player:
		parent.attack_cooldown_timer.start()
	
	if not audioclips.is_empty():
		var audio = audioclips.pick_random()
		SFX_MANAGER.play_sfx_at(audio, parent.global_position, 0, 0.95, 1.05)

func unlock_input() -> void:
	input_lock = false
	change_state()

func change_state() -> void:
	buffer_reset = 0
	if not input_lock:
		if action_buffered:
			parent.velocity = Vector3.ZERO
			state_machine.set_state(action_buffered)

func _unhandled_input(event: InputEvent) -> void:
	if parent == Globals.player:
		if event.is_action_pressed("attack"):
			parent.uppercut_timer.start()
		if event.is_action_released('attack'):
			parent.uppercut_timer.stop()
			if chain != 0:
				action_buffered = 'Attack0' + str(chain)
				change_state()
		if event.is_action_pressed('jump') and parent.is_on_floor():
			action_buffered = 'Jump'
			change_state()
		if event.is_action_pressed('item_01'):
			if parent.item01 != null:
				parent.item01.activate()
		if event.is_action_pressed('item_02'):
			if parent.item02 != null:
				parent.item02.activate()

func update_state(delta : float) -> void:
	if action_buffered != '':
		if buffer_reset < buffer_reset_max:
			buffer_reset += delta
		else:
			action_buffered = ''
	
	if movement_speed != Vector2.ZERO and runtime < movement_duration:
		runtime += delta
		var movement_power : float = movement_curve.sample_baked(runtime / movement_duration)
		var motion : Vector2 = movement_speed * movement_power
		
		parent.velocity.x = motion.x * direction
		if air_attack:
			parent.apply_gravity(delta)
		else:
			parent.velocity.y = motion.y
		
		parent.move_and_slide()

func custom_movement(delta) -> void:
	pass

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func anim_finished(anim_name : String) -> void:
	if anim_name == name:
		if parent.is_on_floor():
			state_machine.set_state(state_machine.get_child(0).name)
		else:
			state_machine.set_state('Fall')
