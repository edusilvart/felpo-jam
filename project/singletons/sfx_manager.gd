extends Node



var rng = RandomNumberGenerator.new()

func play_sfx(audio_path, volume : float, pitch_min : float, pitch_max : float) -> void:
	var player = AudioStreamPlayer.new()
	var audio = load(audio_path)
	player.stream = audio
	player.volume_db = volume
	rng.randomize()
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.bus = 'SFX'
	player.finished.connect(player.queue_free)
	
	add_child(player)
	player.play(0.0)

func play_sfx_at(audio_path, position : Vector2, volume : float, pitch_min : float, pitch_max : float) -> void:
	var player = AudioStreamPlayer2D.new()
	var audio = load(audio_path)
	player.stream = audio
	player.volume_db = volume
	rng.randomize()
	player.pitch_scale = randf_range(pitch_min, pitch_max)
	player.bus = 'SFX'
	player.finished.connect(player.queue_free)
	player.global_position = position
	
	add_child(player)
	player.play(0.0)


func _on_audio_stream_player_finished() -> void:
	pass # Replace with function body.
