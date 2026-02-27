extends Node3D


var next_scene : String = "res://scenes/main_menu.tscn"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_node('Particles').get_children():
		node.start(Vector3.ZERO)
	
	await get_tree().process_frame
	
	for node in get_node('Particles02').get_children():
		node.emitting = true
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	ScenesManager.change_scene(next_scene, self)
