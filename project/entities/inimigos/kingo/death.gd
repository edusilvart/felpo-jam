extends State
# kingo DEATH

@export var audioclip : AudioStream
@export var voiceclip : AudioStream

var end_delay : float = 6
var timer := Timer.new()

func _ready() -> void:
	add_child(timer)
	timer.wait_time = end_delay
	timer.one_shot = true
	timer.timeout.connect(end)

func enter_state() -> void:
	parent.HUD.quick_flash()
	
	var enemies = get_tree().get_nodes_in_group('Enemies')
	if enemies.size() > 0:
		for enemy in enemies:
			if enemy != parent:
				enemy.queue_free()
	
	Globals.hit_stop(1)
	anim_player.play('Death')
	parent.get_parent().change_state('End')
	SFX_MANAGER.play_sfx_at(audioclip, parent.global_position, 0, 1, 1)
	SFX_MANAGER.play_sfx_at(voiceclip, parent.global_position, 0, 0.9, 1.1)

func small_shake() -> void:
	Globals.camera.shake = 0.2

func big_shake() -> void:
	Globals.camera.shake = 3
	parent.drop_shadow.queue_free()

func update_state(_delta : float) -> void:
	pass

func get_transition() -> void:
	pass

func exit_state() -> void:
	pass

func end() -> void:
	parent.get_parent().change_state('END')

func anim_finished(anim_name : String) -> void:
	if anim_name == 'Death':
		parent.HUD.end()
		timer.start()
