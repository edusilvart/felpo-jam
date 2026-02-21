class_name VFX extends Node3D


var particles_finished : int = 0

func start(spawn_position : Vector3) -> void:
	global_position = spawn_position
	
	for child in get_children():
		child.emitting = true
		child.finished.connect(update_particles_count)

func update_particles_count() -> void:
	particles_finished += 1
	if particles_finished == get_child_count():
		queue_free()
