extends Node

@onready var select_sfx : AudioStream = preload('res://interfaces/menu1.mp3')
@onready var cancel_sfx : AudioStream = preload('res://interfaces/menu2.mp3')

var rng = RandomNumberGenerator.new()

func play_sfx(audio, volume : float, pitch_min : float, pitch_max : float) -> void:
	var player = AudioStreamPlayer.new()
	player.stream = audio
	player.volume_db = volume
	rng.randomize()
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.bus = 'SFX'
	player.finished.connect(player.queue_free)
	
	add_child(player)
	player.play(0.0)

func play_sfx_at(audio, position : Vector3, volume : float, pitch_min : float, pitch_max : float) -> void:
	var player = AudioStreamPlayer3D.new()
	player.stream = audio
	player.volume_db = volume
	rng.randomize()
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.bus = 'SFX'
	player.finished.connect(player.queue_free)
	add_child(player)
	player.global_position = position
	player.play(0.0)
	

func select() -> void:
	play_sfx(select_sfx, 0, 0.5, 1.5)

func cancel() -> void:
	play_sfx(cancel_sfx, 0, 0.5, 1.5)
