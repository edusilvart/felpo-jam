extends State
# kingo SHOUT


var spawn_num : int = 3
var spawn_spread_distance : float = 1.3

func enter_state() -> void:
	anim_player.play('Shout')

func spawn_enemies() -> void:
	for n in spawn_num:
		var enemy = Globals.wave_manager.ENEMY_TYPES.keys().pick_random()
		var random_pos = Globals.wave_manager.random_point(spawn_spread_distance)
		var enemy_pos = parent.global_position + random_pos
		Globals.wave_manager.spawn_enemy(enemy, enemy_pos)
		await get_tree().create_timer(0.1).timeout

func update_state(delta : float) -> void:
	parent.apply_gravity(delta)
	parent.apply_movement(Vector2.ZERO, parent.acceleration, delta)

func get_transition() -> void:
	pass

func exit_state() -> void:
	parent.shout_timer.start()

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Shout':
		state_machine.set_state('Idle')
