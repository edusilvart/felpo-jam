extends State
# kingo SHOOT


@onready var bolas_scn = preload('res://entities/inimigos/kingo/paper_ball.tscn')

@export var audioclips : Array[AudioStream]

var direction : Vector2
var tween : Tween
var num_shots : int = 3
var bolas_shot : int = 0

func enter_state() -> void:
	anim_player.play('Shoot_Charge')
	tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(parent.pivot, 'scale', Vector3(0.8, 1.2, 1), 0.3)
	bolas_shot = 0

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration * 0.5, delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	if tween:
		tween.kill()
	parent.pivot.scale = Vector3.ONE
	parent.shoot_timer.start()

func shoot() -> void:
	anim_player.play('Shoot')
	var shoot_angle = 15 # offset by this ammount
	var shoot_direction : Vector3 = (Globals.player.global_position - parent.global_position).normalized()
	var angle_to_player : float = rad_to_deg(atan2(shoot_direction.x, shoot_direction.z))
	
	var bola = bolas_scn.instantiate()
	parent.get_parent().add_child(bola)
	bola.global_position = parent.global_position + Vector3(0, 0, 0.1)
	bola.shoot(angle_to_player + shoot_angle * bolas_shot)
	bolas_shot += 1
	
	var sound = audioclips.pick_random()
	SFX_MANAGER.play_sfx_at(sound, parent.global_position, 0, 0.95, 1.05)

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Shoot_Charge':
		shoot()
	if anim_name == 'Shoot':
		if bolas_shot < num_shots:
			shoot()
		else:
			state_machine.set_state('Idle')
