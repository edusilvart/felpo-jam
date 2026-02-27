extends Item


@onready var cachorro_scn : PackedScene = preload("res://entities/cachorro/cachorro.tscn")
var cachorro

func enter() -> void:
	cachorro = cachorro_scn.instantiate()
	parent.get_parent().add_child(cachorro)
	cachorro.global_position = parent.global_position

func update(_delta) -> void:
	pass

func exit() -> void:
	pass
