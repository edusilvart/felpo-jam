extends Node


var camera : Node3D
var player : Entity
var HUD : Control
var wave_manager : Node

func hit_stop(duration : float) -> void:
	Engine.time_scale = 0.3
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(Engine, "time_scale", 1, duration)
