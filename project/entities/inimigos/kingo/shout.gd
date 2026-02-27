extends State
# kingo SHOUT


@export var audioclip : AudioStream
@export var voiceclip : AudioStream

var spawn_num : int = 3
var spawn_spread_distance : float = 0.5

func enter_state() -> void:
	anim_player.play('Shout')
	
	SFX_MANAGER.play_sfx_at(audioclip, parent.global_position, 0, 0.95, 1.05)
	SFX_MANAGER.play_sfx_at(voiceclip, parent.global_position, 0, 1, 1)

func spawn_enemies() -> void:
	for n in spawn_num:
		var enemy = Globals.wave_manager.get_enemy()
		var random_pos = Globals.wave_manager.random_point(spawn_spread_distance)
		var enemy_pos = parent.global_position + random_pos
		Globals.wave_manager.spawn_enemy(enemy, enemy_pos)

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
