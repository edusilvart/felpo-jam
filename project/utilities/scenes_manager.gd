extends Node


@onready var transition_scn : PackedScene = preload("res://interfaces/transition.tscn")
@onready var loading_screen_scn : PackedScene = preload('res://interfaces/loading_screen.tscn')

var loading_screen
var transition
var current_scene : Node

func _ready() -> void:
	transition = transition_scn.instantiate()
	add_child(transition)

func change_scene(new_scene : String, caller) -> void:
	await transition.enter()
	caller.queue_free()
	
	loading_screen = loading_screen_scn.instantiate()
	add_child(loading_screen)
	loading_screen.load_scene(new_scene)
	loading_screen.finished_loading.connect(finished_loading)

func finished_loading(packed_scene: PackedScene):
	if current_scene != null:
		current_scene.queue_free()
	
	current_scene = packed_scene.instantiate()
	get_tree().root.add_child(current_scene)
	get_tree().current_scene = current_scene
	
	loading_screen.queue_free()
	transition.leave()
