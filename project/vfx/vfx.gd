class_name VFX extends Node3D


@export var particles : bool = true # if not it uses an animation player
var particles_finished : int = 0

func start(spawn_position : Vector3) -> void:
	global_position = spawn_position
	
	if particles:
		for child in get_children():
			child.emitting = true
			child.finished.connect(update_particles_count)
	else:
		get_node('AnimationPlayer').animation_finished.connect(anim_finished)
		get_node('AnimationPlayer').play('Activate')

func update_particles_count() -> void:
	particles_finished += 1
	if particles_finished == get_child_count():
		queue_free()

func anim_finished(_anim_name) -> void:
	queue_free()
