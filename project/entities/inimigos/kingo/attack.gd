extends State
# kingo ATTACK

@onready var dust_vfx : PackedScene = preload('res://vfx/run_dust.tscn')

var direction : Vector3
var tween : Tween

func enter_state() -> void:
	anim_player.play('Attack')
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(parent.pivot, 'scale', Vector3(0.8, 1.2, 1), 0.3)
	
	parent.hitbox.instigator = parent
	parent.hitbox.heavy_hit = true
	parent.hitbox.damage = 2
	
	if Globals.player.global_position.x > parent.global_position.x and not parent.looking_right:
		parent.flip(true)
	if Globals.player.global_position.x < parent.global_position.x and parent.looking_right:
		parent.flip(false)

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration * 0.5, delta)

func get_transition() -> void:
	pass

func activate() -> void:
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	parent.pivot.scale = Vector3(1.3, 0.7, 1)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(parent.pivot, 'scale', Vector3.ONE, 0.2)
	var target_direction = (Globals.player.global_position - parent.global_position).normalized()
	direction = Vector3(target_direction.x, 0, target_direction.z)
	
	parent.hitbox.knockback = (direction + Vector3(0, 1, 0)) * 4
	
	if direction.x > 0 and not parent.looking_right:
		parent.flip(true)
	if direction.x < 0 and parent.looking_right:
		parent.flip(false)
	
	parent.velocity = direction * parent.speed * 2
	
	var dust = dust_vfx.instantiate()
	parent.add_child(dust)
	dust.start(parent.pivot.global_position)

func exit_state() -> void:
	if tween:
		tween.kill()
	parent.pivot.scale = Vector3.ONE
	parent.attack_timer.start()

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Attack':
		state_machine.set_state('Idle')
