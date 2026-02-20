extends Item


@onready var clipe_scene : PackedScene = preload("res://items/clipe.tscn")

func enter() -> void:
	var clipe = clipe_scene.instantiate()
	parent.get_parent().add_child(clipe)
	clipe.global_position = parent.global_position

func exit() -> void:
	pass
