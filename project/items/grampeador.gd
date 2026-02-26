extends Item


@onready var grampo_scene : PackedScene = preload("res://items/grampo.tscn")
var num_grampos : float = 6 # numero de grampos
var grampo_angle : float = 0

func enter() -> void:
	grampo_angle = 360 / num_grampos
	
	for n in num_grampos:
		var grampo = grampo_scene.instantiate()
		parent.get_parent().add_child(grampo)
		grampo.global_position = parent.global_position
		grampo.shoot(n * grampo_angle)

func exit() -> void:
	pass
