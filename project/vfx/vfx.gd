extends Node3D


func start(spawn_position : Vector3) -> void:
	global_position = spawn_position
	
	for child in get_children():
		child.emitting = true
		child.finished.connect(queue_free)
