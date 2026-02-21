extends State
# player ON GROUND



@onready var land_dust = preload('res://vfx/land_dust.tscn')
@onready var run_dust = preload('res://vfx/run_dust.tscn')

var current_anim = ''
var new_anim = ''
var tween : Tween

func enter_state() -> void:
	current_anim = ''
	
	if prev_state == 'Jump' or prev_state == 'Fall':
		new_anim = 'Idle'
		parent.pivot.scale = Vector3(1.3, 0.7, 1)
		tween = get_tree().create_tween()
		tween.set_trans(Tween.TRANS_CUBIC)
		tween.set_ease(Tween.EASE_OUT)
		tween.tween_property(parent.pivot, 'scale', Vector3.ONE, 0.2)
		
		var dust = land_dust.instantiate()
		parent.get_parent().add_child(dust)
		dust.start(parent.pivot.global_position)
	else:
		new_anim = 'Idle'

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('attack'):
		state_machine.set_state('Attack01')
	if event.is_action_pressed('jump'):
		state_machine.set_state('Jump')
	if event.is_action_pressed('item_01'):
		if parent.item01 != null:
			parent.item01.activate()
	if event.is_action_pressed('item_02'):
		if parent.item02 != null:
			parent.item02.activate()

func update_state(delta : float) -> void:
	var dir_input : Vector2 = parent.get_dir_input()
	parent.apply_movement(dir_input * parent.speed, parent.acceleration, delta)
	parent.apply_gravity(delta)
	
	if dir_input.x < 0:
		if parent.looking_right:
			parent.flip(false)
	if dir_input.x > 0:
		if not parent.looking_right:
			parent.flip(true)
	
	if dir_input != Vector2.ZERO:
		new_anim = 'Run'
		if parent.prev_vel.length() < 0.5:
			var dust = run_dust.instantiate()
			parent.get_parent().add_child(dust)
			dust.look_at(parent.pivot.global_position, Vector3.UP)
			var spawn_point = parent.pivot.global_position
			if dir_input.x > 0:
				spawn_point.x -= 0.2
			if dir_input.x < 0:
				spawn_point.x += 0.2
			
			dust.start(spawn_point)
	else:
		new_anim = 'Idle'
	
	if new_anim != current_anim:
		current_anim = new_anim
		#anim_player.play(current_anim)

func get_transition() -> void:
	if not parent.is_on_floor():
		state_machine.set_state('Fall')

func exit_state() -> void:
	parent.pivot.scale = Vector3.ONE
	
	if tween:
		tween.kill()

func anim_finished(_anim_name : String) -> void:
	pass
